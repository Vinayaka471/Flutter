package com.example.shabadimath_calendar.panchanga

import android.graphics.drawable.Drawable
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.recyclerview.widget.RecyclerView
import androidx.viewpager2.widget.ViewPager2
import com.bumptech.glide.Glide
import com.bumptech.glide.load.DataSource
import com.bumptech.glide.load.engine.GlideException
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.request.RequestListener
import com.bumptech.glide.request.target.Target
import com.bumptech.glide.load.resource.drawable.DrawableTransitionOptions
import com.example.shabadimath_calendar.R
import java.util.Calendar
import java.util.Locale

class IndhinaPachangaActivity : AppCompatActivity() {
    companion object {
        const val EXTRA_MONTH = "extra_month"
        const val EXTRA_YEAR = "extra_year"
        const val EXTRA_ASSET_PATH = "extra_asset_path"
        const val EXTRA_ASSET_MAP = "extra_asset_map"
        private const val MONTH_WINDOW = 120
        private const val BASE_URL = "https://kannadacalendar.in/wp-content/kannada/panchanga"
    }

    private lateinit var toolbar: Toolbar
    private lateinit var viewPager: ViewPager2
    private lateinit var pagerAdapter: PanchangaPagerAdapter
    private var currentPosition: Int = 0
    private var assetMap: Map<String, String> = emptyMap()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_indhina_pachanga)

        toolbar = findViewById(R.id.toolbar)
        viewPager = findViewById(R.id.panchanga_pager)

        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.title = getString(R.string.panchanga_title)
        toolbar.setNavigationOnClickListener { onBackPressedDispatcher.onBackPressed() }

        val month = intent.getIntExtra(EXTRA_MONTH, -1)
        val year = intent.getIntExtra(EXTRA_YEAR, -1)
        val initialAsset = intent.getStringExtra(EXTRA_ASSET_PATH)
        assetMap = (intent.getSerializableExtra(EXTRA_ASSET_MAP) as? HashMap<*, *>)?.mapNotNull { entry ->
            val key = entry.key as? String
            val value = entry.value as? String
            if (key != null && value != null) key to value else null
        }?.toMap() ?: emptyMap()

        if (month !in 1..12 || year <= 0) {
            finish()
            return
        }

        pagerAdapter = PanchangaPagerAdapter(this, year, month, assetMap)
        viewPager.adapter = pagerAdapter
        viewPager.offscreenPageLimit = 1
        currentPosition = pagerAdapter.initialPosition
        viewPager.setCurrentItem(currentPosition, false)
        updateToolbarSubtitle(currentPosition)
        pagerAdapter.prefetchAround(currentPosition)

        viewPager.registerOnPageChangeCallback(object : ViewPager2.OnPageChangeCallback() {
            override fun onPageSelected(position: Int) {
                currentPosition = position
                updateToolbarSubtitle(position)
                pagerAdapter.prefetchAround(position)
            }
        })
    }

    private fun updateToolbarSubtitle(position: Int) {
        toolbar.subtitle = pagerAdapter.labelForPosition(position)
    }

    private data class MonthEntry(val year: Int, val month: Int)

    private class PanchangaPagerAdapter(
        private val activity: AppCompatActivity,
        startYear: Int,
        startMonth: Int,
        private val assetMap: Map<String, String>
    ) : RecyclerView.Adapter<PanchangaPagerAdapter.PanchangaViewHolder>() {

        private val locale = Locale("kn", "IN")
        private val entries: List<MonthEntry>
        val initialPosition: Int

        init {
            val months = mutableListOf<MonthEntry>()
            val calendar = Calendar.getInstance(locale).apply {
                set(Calendar.YEAR, startYear)
                set(Calendar.MONTH, startMonth - 1)
                set(Calendar.DAY_OF_MONTH, 1)
            }
            val working = calendar.clone() as Calendar
            working.add(Calendar.MONTH, -MONTH_WINDOW)

            val total = MONTH_WINDOW * 2 + 1
            repeat(total) {
                months.add(MonthEntry(working.get(Calendar.YEAR), working.get(Calendar.MONTH) + 1))
                working.add(Calendar.MONTH, 1)
            }
            entries = months
            initialPosition = MONTH_WINDOW
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PanchangaViewHolder {
            val view = LayoutInflater.from(parent.context).inflate(R.layout.item_panchanga_page, parent, false)
            return PanchangaViewHolder(view)
        }

        override fun onBindViewHolder(holder: PanchangaViewHolder, position: Int) {
            val entry = entries[position]
            holder.bind(entry, labelForEntry(entry))
        }

        override fun getItemCount(): Int = entries.size

        fun entryForPosition(position: Int): MonthEntry = entries[position]

        fun labelForPosition(position: Int): String = labelForEntry(entries[position])

        fun prefetchAround(position: Int) {
            val indices = listOf(position - 1, position + 1)
            indices.filter { it in entries.indices }.forEach { idx ->
                val entry = entries[idx]
                val asset = assetFor(entry)
                if (asset != null) {
                    Glide.with(activity)
                        .load(asset)
                        .diskCacheStrategy(DiskCacheStrategy.ALL)
                        .preload()
                } else {
                    Glide.with(activity)
                        .load(buildUrl(entry))
                        .diskCacheStrategy(DiskCacheStrategy.ALL)
                        .preload()
                }
            }
        }

        private fun buildUrl(entry: MonthEntry): String {
            val formattedMonth = String.format(Locale.US, "%02d", entry.month)
            return "$BASE_URL/${entry.year}/${formattedMonth}-${entry.year}.jpg"
        }

        private fun assetFor(entry: MonthEntry): String? {
            val key = "${entry.year.toString().padStart(4, '0')}-${entry.month.toString().padStart(2, '0')}"
            return assetMap[key]
        }

        private fun labelForEntry(entry: MonthEntry): String {
            val calendar = Calendar.getInstance(locale).apply {
                set(Calendar.YEAR, entry.year)
                set(Calendar.MONTH, entry.month - 1)
            }
            val monthName = calendar.getDisplayName(Calendar.MONTH, Calendar.LONG, locale) ?: entry.month.toString()
            return "$monthName ${entry.year}"
        }

        inner class PanchangaViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
            private val monthTitle: TextView = itemView.findViewById(R.id.month_title)
            private val imageView: ImageView = itemView.findViewById(R.id.panchanga_image)
            private val progressBar: ProgressBar = itemView.findViewById(R.id.loading_indicator)
            private val statusMessage: TextView = itemView.findViewById(R.id.status_message)

            fun bind(entry: MonthEntry, label: String) {
                monthTitle.text = label
                statusMessage.visibility = View.GONE
                progressBar.visibility = View.VISIBLE
                imageView.visibility = View.GONE

                val asset = assetFor(entry)

                val glideRequest = Glide.with(imageView)
                    .load(asset ?: buildUrl(entry))
                    .fitCenter()
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
                    .transition(DrawableTransitionOptions.withCrossFade())
                    .thumbnail(0.25f)
                    .placeholder(android.R.color.darker_gray)
                    .listener(object : RequestListener<Drawable> {
                        override fun onLoadFailed(
                            e: GlideException?,
                            model: Any?,
                            target: Target<Drawable>,
                            isFirstResource: Boolean
                        ): Boolean {
                            progressBar.visibility = View.GONE
                            imageView.visibility = View.GONE
                            statusMessage.visibility = View.VISIBLE
                            statusMessage.text = activity.getString(R.string.panchanga_load_error)
                            return false
                        }

                        override fun onResourceReady(
                            resource: Drawable,
                            model: Any,
                            target: Target<Drawable>,
                            dataSource: DataSource,
                            isFirstResource: Boolean
                        ): Boolean {
                            progressBar.visibility = View.GONE
                            statusMessage.visibility = View.GONE
                            imageView.visibility = View.VISIBLE
                            return false
                        }
                    })

                glideRequest.into(imageView)
            }
        }
    }
}
