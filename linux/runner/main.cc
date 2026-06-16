#include "Feedback_Application.h"

int main(int argc, char** argv) {
  g_autoptr(MyApplication) app = Feedback_Application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
