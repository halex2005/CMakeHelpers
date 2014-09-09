CMakeHelpers
============

CMakeHelpers is a set of cmake scripts that never will be in official cmake distribution. Find*-scipts are mostly based on FindBoost.cmake that included in official distribution of cmake.

Using scripts in your project
-----------------------------

To use scripts you can download single files of interest to your repository.

Also you can use this repository as submodule.

### Using git submodule

Imagine that you have cmake-based project in `ProjectDir` folder.
You can initialize CMakeHelpers submodule with commands:

    git submodule add https://github.com/halex2005/CMakeHelpers.git
    git commit -m "init CMakeHelpers submodule"

When you need to clone your repository you should init submodules with

    git submodule init
    git submodule update

### Using scripts in CMakeFiles.txt

To use contents of `ProjectDir/CMakeHelpers` folder you should add this lines to your `ProjectDir/CMakeLists.txt` file:

    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMakeHelpers")

Then you can use `find_package` command in your `CMakeLists.txt` files, i.e. in case of `FindResiprocate.cmake`:

    find_package(Resiprocate 1.9 EXACT COMPONENTS resip recon)
    if (NOT Resiprocate_FOUND)
        message(SEND_ERROR "Failed to find Resiprocate")
        return()
    else()
        include_directories(${Resiprocate_INCLUDE_DIRS})
        link_directories(${Resiprocate_LIBRARY_DIRS})
    endif()
    # and you can add target links like:
    # target_link_libraries(<target-name> ${Resiprocate_LIBRARIES})


Licensing
---------

CMakeHelpers is distributed under [Apache v2.0 License](LICENSE).

[![PayPal donate button](http://img.shields.io/paypal/donate.png?color=yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=7RR8B7SRHFX5Q "Donate once-off to this project using Paypal")
[![Gratipay donate button](http://img.shields.io/gratipay/halex2005.svg)](https://gratipay.com/halex2005/ "Donate weekly to this project using Gratipay")