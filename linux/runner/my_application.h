#ifndef FLUTTER_Feedback_AppLICATION_H_
#define FLUTTER_Feedback_AppLICATION_H_

#include <gtk/gtk.h>

G_DECLARE_FINAL_TYPE(MyApplication, Feedback_Application, MY, APPLICATION,
                     GtkApplication)

/**
 * Feedback_Application_new:
 *
 * Creates a new Flutter-based application.
 *
 * Returns: a new #MyApplication.
 */
MyApplication* Feedback_Application_new();

#endif  // FLUTTER_Feedback_AppLICATION_H_
