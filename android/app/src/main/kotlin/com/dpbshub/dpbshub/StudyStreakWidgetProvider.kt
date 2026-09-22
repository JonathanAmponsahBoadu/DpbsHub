package com.dpbshub.dpbshub

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Color
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.util.Calendar
import java.util.TimeZone

/**
 * The home-screen "study streak" widget. The Dart side only stores two
 * values (see StudyWidgetService): the current streak and the local epoch
 * day you last studied. Everything else — studied today? streak at risk?
 * how many hours are left? — is derived here from the current date, so the
 * widget stays correct at midnight and through the evening countdown even if
 * the app hasn't been opened since.
 *
 * When the streak is genuinely about to break it switches to a second layout
 * whose flame and button auto-flip, so the widget visibly blinks.
 */
class StudyStreakWidgetProvider : HomeWidgetProvider() {

    private data class WidgetState(
        val background: Int,
        val flame: String,
        val message: String,
        val cta: String,
        val ctaColor: String,
        val urgent: Boolean = false,
    )

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val streak = widgetData.getString("streak", null)?.toIntOrNull() ?: 0
        val lastStudyDay = widgetData.getString("lastStudyEpochDay", null)?.toLongOrNull()
        val today = epochDayNow()

        var studiedToday = lastStudyDay == today
        // A streak survives until the end of the day after you last studied.
        val streakAlive = lastStudyDay != null && lastStudyDay >= today - 1
        var shownStreak = if (streakAlive) streak else 0
        var hoursLeft = 24 - Calendar.getInstance().get(Calendar.HOUR_OF_DAY)

        // Settings -> "Preview notifications & widget" can pin the widget to
        // one of its looks so you can see them without waiting for the right
        // moment. It expires by itself, so a forgotten preview can't leave
        // the widget showing made-up numbers.
        val previewState = widgetData.getString("previewState", null)?.takeIf { it.isNotBlank() }
        val previewAt = widgetData.getString("previewAt", null)?.toLongOrNull() ?: 0L
        if (previewState != null && System.currentTimeMillis() - previewAt < PREVIEW_MILLIS) {
            when (previewState) {
                "studied" -> { studiedToday = true; shownStreak = 5 }
                "atrisk" -> { studiedToday = false; shownStreak = 5; hoursLeft = 10 }
                "urgent" -> { studiedToday = false; shownStreak = 5; hoursLeft = 3 }
                else -> { studiedToday = false; shownStreak = 0 }
            }
        }

        val state = when {
            studiedToday -> WidgetState(
                R.drawable.widget_bg_emerald,
                "🔥",
                "You studied today. Great work!",
                "Keep going",
                "#0C7A54",
            )
            shownStreak > 0 && hoursLeft <= 6 -> WidgetState(
                R.drawable.widget_bg_warning,
                "⏳",
                "Only ${hoursLeft}h left to keep your $shownStreak-day streak!",
                "Study now",
                "#C2410C",
                urgent = true,
            )
            shownStreak > 0 -> WidgetState(
                R.drawable.widget_bg_warning,
                "🔥",
                "Study today to keep your $shownStreak-day streak alive.",
                "Study now",
                "#C2410C",
            )
            else -> WidgetState(
                R.drawable.widget_bg_idle,
                "🌱",
                "Start a new streak today — one verse is enough.",
                "Begin",
                "#0C7A54",
            )
        }

        val launch = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
        val ctaColor = Color.parseColor(state.ctaColor)
        val layout =
            if (state.urgent) R.layout.study_streak_widget_urgent else R.layout.study_streak_widget

        for (widgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, layout).apply {
                setInt(R.id.widget_root, "setBackgroundResource", state.background)
                setTextViewText(R.id.widget_streak, shownStreak.toString())
                setTextViewText(R.id.widget_message, state.message)
                if (state.urgent) {
                    setTextViewText(R.id.widget_flame_a, state.flame)
                    setTextViewText(R.id.widget_flame_b, "⚠️")
                    setTextViewText(R.id.widget_cta_a, state.cta)
                    setTextViewText(R.id.widget_cta_b, "Save your streak!")
                    setTextColor(R.id.widget_cta_a, ctaColor)
                    setTextColor(R.id.widget_cta_b, ctaColor)
                } else {
                    setTextViewText(R.id.widget_flame, state.flame)
                    setTextViewText(R.id.widget_cta, state.cta)
                    setTextColor(R.id.widget_cta, ctaColor)
                }
                setOnClickPendingIntent(R.id.widget_root, launch)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private companion object {
        const val PREVIEW_MILLIS = 10 * 60 * 1000L
    }

    /** Days since 1970-01-01 for today's *local* calendar date. */
    private fun epochDayNow(): Long {
        val now = System.currentTimeMillis()
        val offset = TimeZone.getDefault().getOffset(now)
        return Math.floorDiv(now + offset, 86_400_000L)
    }
}
