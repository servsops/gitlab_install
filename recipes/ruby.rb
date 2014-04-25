#
# Cookbook Name:: gitlab_install
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "ruby_build"

gitlab_install_ruby "2.1.1" do
  prefix_path "/user/local/"
  patch 	<<-PATCH
Index: ext/readline/readline.c
===================================================================
--- ext/readline/readline.c	(revision 45224)
+++ ext/readline/readline.c	(revision 45225)
@@ -1974,7 +1974,7 @@
 
     rl_attempted_completion_function = readline_attempted_completion_function;
 #if defined(HAVE_RL_PRE_INPUT_HOOK)
-    rl_pre_input_hook = (Function *)readline_pre_input_hook;
+    rl_pre_input_hook = (rl_hook_func_t *)readline_pre_input_hook;
 #endif
 #ifdef HAVE_RL_CATCH_SIGNALS
     rl_catch_signals = 0;
Index: ext/readline/extconf.rb
===================================================================
--- ext/readline/extconf.rb	(revision 45239)
+++ ext/readline/extconf.rb	(revision 45240)
@@ -19,6 +19,10 @@
   return super(func, headers)
 end
 
+def readline.have_type(type)
+  return super(type, headers)
+end
+
 dir_config('curses')
 dir_config('ncurses')
 dir_config('termcap')
@@ -94,4 +98,8 @@
 readline.have_func("rl_redisplay")
 readline.have_func("rl_insert_text")
 readline.have_func("rl_delete_text")
+unless readline.have_type("rl_hook_func_t")
+  $DEFS << "-Drl_hook_func_t=Function"
+end
+
 create_makefile("readline")
PATCH
  action :install
end

gem_package "bundler" do
  gem_binary "/usr/local/bin/gem"
  options "--no-ri --no-rdoc"
end
