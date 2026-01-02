#include "my_application.h"
#include <X11/Xlib.h> // <--- Add this import

int main(int argc, char** argv) {
  XInitThreads(); // <--- Add this call FIRST
  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}