package com.example.shabadimath_calendar.panchanga

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.bumptech.glide.Glide
import com.example.shabadimath_calendar.R
import java.util.Locale

class IndhinaPachangaActivity : AppCompatActivity() {
    companion object {
        const val EXTRA_MONTH = "extra_month"
        const val EXTRA_YEAR = "extra_year"
    }

    private lateinit var toolbar: androidx.appcompat.widget.Toolbar
    private lateinit var monthTitle: TextView
    private lateinit var statusMessage: TextView
    private lateinit var imageView: ImageView
    private lateinit var progressBar: ProgressBar

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_indhina_pachanga)

        toolbar = findViewById(R.id.toolbar)
        monthTitle = findViewById(R.id.month_title)
        imageView = findViewById(R.id.panchanga_image)
        statusMessage = findViewById(R.id.status_message)
        progressBar = findViewById(R.id.loading_indicator)

        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.title = getString(R.string.panchanga_title)

        val month = intent.getIntExtra(EXTRA_MONTH, -1)
        val year = intent.getIntExtra(EXTRA_YEAR, -1)

        if (month !in 1..12 || year <= 0) {
            showError(getString(R.string.panchanga_load_error))
            return
        }

        val monthName = monthName(month)
        monthTitle.text = "$monthName $year"

        loadPanchanga(month, year)
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.panchanga_menu, menu)
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            android.R.id.home -> {
                onBackPressedDispatcher.onBackPressed()
                true
            }
            R.id.action_open_site -> {
                val url = "https://kannadacalendar.in"
                startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }

    private fun monthName(month: Int): String {
        val locale = Locale("kn", "IN")
        return locale.getDisplayLanguage(Locale.ENGLISH).let {
            val calendar = java.util.Calendar.getInstance(locale)
            calendar.set(java.util.Calendar.MONTH, month - 1)
            calendar.getDisplayName(java.util.Calendar.MONTH, java.util.Calendar.LONG, locale) ?: month.toString()
        }
    }

    private fun loadPanchanga(month: Int, year: Int) {
        progressBar.visibility = android.view.View.VISIBLE
        statusMessage.visibility = android.view.View.GONE
        imageView.visibility = android.view.View.GONE

        val formattedMonth = String.format(Locale.US, "%02d", month)
        val imageUrl = "https://kannadacalendar.in/wp-content/kannada/panchanga/$year/${formattedMonth}-$year.jpg"

        Glide.with(this)
            .load(imageUrl)
            .fitCenter()
            .placeholder(android.R.color.darker_gray)
            .error(android.R.color.darker_gray)
            .into(imageView)

        progressBar.visibility = android.view.View.GONE
        imageView.visibility = android.view.View.VISIBLE
    }

    private fun showError(message: String) {
        progressBar.visibility = android.view.View.GONE
        statusMessage.visibility = android.view.View.VISIBLE
        statusMessage.text = message
        imageView.visibility = android.view.View.GONE
    }
}
