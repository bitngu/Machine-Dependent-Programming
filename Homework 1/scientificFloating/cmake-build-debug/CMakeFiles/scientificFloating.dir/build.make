# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.15

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake

# The command to remove a file.
RM = /Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = "/Users/bitnguyen/Desktop/UCDavis/Spring 2020/ECS 50/Homework/Homework 1/scientificFloating"

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = "/Users/bitnguyen/Desktop/UCDavis/Spring 2020/ECS 50/Homework/Homework 1/scientificFloating/cmake-build-debug"

# Include any dependencies generated for this target.
include CMakeFiles/scientificFloating.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/scientificFloating.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/scientificFloating.dir/flags.make

CMakeFiles/scientificFloating.dir/scientificFloating.cpp.o: CMakeFiles/scientificFloating.dir/flags.make
CMakeFiles/scientificFloating.dir/scientificFloating.cpp.o: ../scientificFloating.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir="/Users/bitnguyen/Desktop/UCDavis/Spring 2020/ECS 50/Homework/Homework 1/scientificFloating/cmake-build-debug/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/scientificFloating.dir/scientificFloating.cpp.o"
	/Library/Developer/CommandLineTools/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/scientificFloating.dir/scientificFloating.cpp.o -c "/Users/bitnguyen/Desktop/UCDavis/Spring 2020/ECS 50/Homework/Homework 1/scientificFloating/scientificFloating.cpp"

CMakeFiles/scientificFloating.dir/scientificFloating.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/scientificFloating.dir/scientificFloating.cpp.i"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E "/Users/bitnguyen/Desktop/UCDavis/Spring 2020/ECS 50/Homework/Homework 1/scientificFloating/scientificFloating.cpp" > CMakeFiles/scientificFloating.dir/scientificFloating.cpp.i

CMakeFiles/scientificFloating.dir/scientificFloating.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/scientificFloating.dir/scientificFloating.cpp.s"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S "/Users/bitnguyen/Desktop/UCDavis/Spring 2020/ECS 50/Homework/Homework 1/scientificFloating/scientificFloating.cpp" -o CMakeFiles/scientificFloating.dir/scientificFloating.cpp.s

# Object files for target scientificFloating
scientificFloating_OBJECTS = \
"CMakeFiles/scientificFloating.dir/scientificFloating.cpp.o"

# External object files for target scientificFloating
scientificFloating_EXTERNAL_OBJECTS =

scientificFloating: CMakeFiles/scientificFloating.dir/scientificFloating.cpp.o
scientificFloating: CMakeFiles/scientificFloating.dir/build.make
scientificFloating: CMakeFiles/scientificFloating.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir="/Users/bitnguyen/Desktop/UCDavis/Spring 2020/ECS 50/Homework/Homework 1/scientificFloating/cmake-build-debug/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable scientificFloating"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/scientificFloating.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/scientificFloating.dir/build: scientificFloating

.PHONY : CMakeFiles/scientificFloating.dir/build

CMakeFiles/scientificFloating.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/scientificFloating.dir/cmake_clean.cmake
.PHONY : CMakeFiles/scientificFloating.dir/clean

CMakeFiles/scientificFloating.dir/depend:
	cd "/Users/bitnguyen/Desktop/UCDavis/Spring 2020/ECS 50/Homework/Homework 1/scientificFloating/cmake-build-debug" && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" "/Users/bitnguyen/Desktop/UCDavis/Spring 2020/ECS 50/Homework/Homework 1/scientificFloating" "/Users/bitnguyen/Desktop/UCDavis/Spring 2020/ECS 50/Homework/Homework 1/scientificFloating" "/Users/bitnguyen/Desktop/UCDavis/Spring 2020/ECS 50/Homework/Homework 1/scientificFloating/cmake-build-debug" "/Users/bitnguyen/Desktop/UCDavis/Spring 2020/ECS 50/Homework/Homework 1/scientificFloating/cmake-build-debug" "/Users/bitnguyen/Desktop/UCDavis/Spring 2020/ECS 50/Homework/Homework 1/scientificFloating/cmake-build-debug/CMakeFiles/scientificFloating.dir/DependInfo.cmake" --color=$(COLOR)
.PHONY : CMakeFiles/scientificFloating.dir/depend

