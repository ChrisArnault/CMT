include(CTest)

#---------------------------------------------------------
function(plustab)
  get_property(tab GLOBAL PROPERTY TAB)

  if("${tab}" STREQUAL "")
    set(tab "1")
  else()
    math(EXPR tab "${tab} + 1")
  endif()

  set_property(GLOBAL PROPERTY TAB "${tab}")
endfunction()

function(moinstab)
  get_property(tab GLOBAL PROPERTY TAB)

  if(("${tab}" STREQUAL "") OR ((tab EQUAL "1")))
  else()
    math(EXPR tab "${tab} - 1")
  endif()

  set_property(GLOBAL PROPERTY TAB "${tab}")
endfunction()

function(cmt_on)
  set_property(GLOBAL PROPERTY MODE on)
endfunction()

function(cmt_off)
  set_property(GLOBAL PROPERTY MODE off)
endfunction()

function(cmt_message text)
  get_property(mode GLOBAL PROPERTY MODE)
  if(mode STREQUAL "on")
    get_property(tab GLOBAL PROPERTY TAB)

    unset(spaces)
    foreach(k RANGE ${tab})
      set(spaces "${spaces}  ")
    endforeach()

    message("${tab}:${spaces}${text}")
  endif()
endfunction()

#---------------------------------------------------------
function(cmt_append_unique_property property_name value)
  plustab()
  get_property(property GLOBAL PROPERTY "${property_name}")
  list(FIND property "${value}" index)
  #cmt_message("cmt_append_unique_property> property_name=${property_name} value=${value} index=${index}")
  if("${index}" EQUAL "-1")
    set_property(GLOBAL APPEND PROPERTY "${property_name}" "${value}")
  endif()
  moinstab()
endfunction()


#---------------------------------------------------------
function(cmt_project name here)
  plustab()

  if("${here}" STREQUAL "")
    set(pwd ${CMAKE_CURRENT_SOURCE_DIR})
  else()
    set(pwd ${here})
  endif()

  project(${name})

  set (CMAKE_VERBOSE_MAKEFILE TRUE)

  get_property(previous GLOBAL PROPERTY CMT_CURRENT_PROJECT)
  set_property(GLOBAL PROPERTY CMT_CURRENT_PROJECT ${name})

  cmt_append_unique_property(CMT_PROJECTS "${name}")

  cmt_message("Entering project ${name} pwd=${pwd} previous=${previous} foo=${foo}")

  set("CMT_${name}_PROJECT_PATH" ${pwd})
  cmt_message("set_property(GLOBAL PROPERTY CMT_${name}_PROJECT_PATH ${pwd})")
  set_property(GLOBAL PROPERTY CMT_${name}_PROJECT_PATH ${pwd})

  #
  # configure CMT policy:
  # Each project provide an 'installarea'
  # and this directory corresponds to 
  #  - INCLUDE_DIRECTORIES
  #  - LINK_DIRECTORIES
  #  - CMAKE_INSTALL_PREFIX
  #
  cmt_message("file(MAKE_DIRECTORY ${pwd}/installarea)")
  file(MAKE_DIRECTORY ${pwd}/installarea)

  ###cmt_message("set_property(DIRECTORY ${CMT_${name}_PROJECT_PATH} PROPERTY INCLUDE_DIRECTORIES ${CMT_${name}_PROJECT_PATH}/installarea) ")
  ###set_property(DIRECTORY ${CMT_${name}_PROJECT_PATH} PROPERTY INCLUDE_DIRECTORIES ${CMT_${name}_PROJECT_PATH}/installarea) 

  cmt_message("set_property(DIRECTORY ${pwd} PROPERTY INCLUDE_DIRECTORIES ${pwd}/installarea) ")
  set_property(DIRECTORY ${pwd} PROPERTY INCLUDE_DIRECTORIES ${pwd}/installarea) 

  cmt_message("set_property(DIRECTORY ${pwd} PROPERTY LINK_DIRECTORIES ${pwd}/installarea) ")
  set_property(DIRECTORY ${pwd} PROPERTY LINK_DIRECTORIES ${pwd}/installarea) 

  cmt_message("set(CMAKE_INSTALL_PREFIX ${pwd}/installarea PARENT_SCOPE)")
  set(CMAKE_INSTALL_PREFIX ${pwd}/installarea PARENT_SCOPE)

  # setup the path definition for the shared libs: PATH for windows
  cmt_message("cmt_path(path ${pwd}/installarea)")
  cmt_path_prepend(path ${pwd}/installarea)

  cmt_message("Project ${name} started...")

  moinstab()
endfunction()

#---------------------------------------------------------
function(cmt_package name)
  plustab()

  set(pwd ${CMAKE_CURRENT_SOURCE_DIR})

  get_property(previous GLOBAL PROPERTY CMT_CURRENT_PACKAGE)
  set_property(GLOBAL PROPERTY CMT_CURRENT_PACKAGE ${name})

  get_property(prefix GLOBAL PROPERTY CMT_${name}_PREFIX)
  get_property(path GLOBAL PROPERTY CMT_${name}_PATH)

  cmt_append_unique_property(CMT_PACKAGES "${name}")

  get_property(project GLOBAL PROPERTY CMT_CURRENT_PROJECT)
  if("${project}" STREQUAL "")
    cmt_project(work ${pwd})
    get_property(project GLOBAL PROPERTY CMT_CURRENT_PROJECT)
    string(REGEX REPLACE "[/][^/]*$" "" path ${pwd})
    cmt_message("set_property(GLOBAL PROPERTY ${name}_ROOT ${pwd}")
    set_property(GLOBAL PROPERTY ${name}_ROOT ${pwd})
  else()
    cmt_message("set_property(GLOBAL PROPERTY ${name}_ROOT ${pwd}")
    set_property(GLOBAL PROPERTY ${name}_ROOT ${pwd})
  endif()

  set_property(GLOBAL PROPERTY "CMT_${name}_PROJECT" "${project}")

  cmt_message("Entering package project=${project} package=${name} prefix=${prefix} path=${path}")

  get_property(CMT_${project}_PROJECT_PATH GLOBAL PROPERTY CMT_${project}_PROJECT_PATH)
  get_property(${name}_ROOT GLOBAL PROPERTY ${name}_ROOT)

  # CMT policy:
  # each package installs a directory <name> into the installarea to receive its header files
  #
  cmt_message ("file(MAKE_DIRECTORY ${CMT_${project}_PROJECT_PATH}/installarea/${name})")
  file(MAKE_DIRECTORY ${CMT_${project}_PROJECT_PATH}/installarea/${name})

  unset(headers)
  cmt_message("file(GLOB headers ${${name}_ROOT}/*/*.h*)")
  file(GLOB headers ${${name}_ROOT}/*/*.h*)
  foreach(f IN LISTS headers)
    if(NOT(f MATCHES ".*[~]"))
      string(REPLACE "${${name}_ROOT}/" "" f "${f}")
      cmt_message("configure_file(${f} '${CMT_${project}_PROJECT_PATH}/installarea/${name}' COPYONLY)")
      configure_file(${f} "${CMT_${project}_PROJECT_PATH}/installarea/${name}" COPYONLY)  
    endif()
  endforeach()

  cmt_message("Package ${name} started...")

  moinstab()
endfunction()

#---------------------------------------------------------
function(cmt_show_projects)
  message("cmt_show_projects>")
  get_property(projects GLOBAL PROPERTY CMT_PROJECTS)
  foreach(project IN LISTS projects)
    get_property(path GLOBAL PROPERTY CMT_${project}_PROJECT_PATH)
    message ("Project ${project} in ${path}")
  endforeach()
endfunction()

#---------------------------------------------------------
function(cmt_show_project project)
  message("cmt_show_project> ${project}")
  get_property(projects GLOBAL PROPERTY CMT_PROJECTS)
  list(FIND projects "${project}" index)
  if("${index}" EQUAL "-1")
    message("Project ${project} not found")
  else()
    get_property(path GLOBAL PROPERTY CMT_${project}_PROJECT_PATH)
    message ("Project ${project} in ${path}")
  endif()
endfunction()

#---------------------------------------------------------
function(cmt_show_packages)
  message("cmt_show_packages>")
  get_property(packages GLOBAL PROPERTY CMT_PACKAGES)
  foreach(package IN LISTS packages)
    get_property(project GLOBAL PROPERTY "CMT_${package}_PROJECT")
    get_property(path GLOBAL PROPERTY "CMT_${package}_PATH")
    get_property(prefix GLOBAL PROPERTY "CMT_${package}_PREFIX")
    message ("Package ${package} in project ${project} Path=${path} ")
  endforeach()
endfunction()

#---------------------------------------------------------
function(cmt_show_package package)
  message("cmt_show_package> ${package}")
  get_property(packages GLOBAL PROPERTY CMT_PACKAGES)
  list(FIND packages "${package}" index)
  if("${index}" EQUAL "-1")
    message("Package ${package} not found")
  else()
    get_property(project GLOBAL PROPERTY "CMT_${package}_PROJECT")
    message ("Package ${package} in project ${project}")
  endif()
endfunction()

#---------------------------------------------------------
function(cmt_show_libraries)
  message("cmt_show_libraries>")
  get_property(libraries GLOBAL PROPERTY CMT_LIBRARIES)
  foreach(lib IN LISTS libraries)
    get_property(project GLOBAL PROPERTY "CMT_${lib}_PROJECT")
    get_property(package GLOBAL PROPERTY "CMT_${lib}_PACKAGE")
    message ("Library ${lib} in package ${package} of project ${project}")
  endforeach()
endfunction()

#---------------------------------------------------------
function(cmt_show_library lib)
  message("cmt_show_library> ${lib}")
  get_property(libraries GLOBAL PROPERTY CMT_LIBRARIES)
  list(FIND libraries "${lib}" index)
  if("${index}" EQUAL "-1")
    message("Library ${lib} not found")
  else()
    get_property(project GLOBAL PROPERTY "CMT_${lib}_PROJECT")
    get_property(package GLOBAL PROPERTY "CMT_${lib}_PACKAGE")
    message ("Library ${lib} in package ${package} of project ${project}")
  endif()
endfunction()

#---------------------------------------------------------
function(cmt_show_executables)
  message("cmt_show_executables>")
  get_property(executables GLOBAL PROPERTY CMT_EXECUTABLES)
  foreach(exe IN LISTS executables)
    get_property(project GLOBAL PROPERTY "CMT_${exe}_PROJECT")
    get_property(package GLOBAL PROPERTY "CMT_${exe}_PACKAGE")
    message ("Executable ${exe} in in package ${package} of project ${project}")
  endforeach()
endfunction()

#---------------------------------------------------------
function(cmt_show_executable exe)
  message("cmt_show_executable> ${exe}")
  get_property(executables GLOBAL PROPERTY CMT_EXECUTABLES)
  list(FIND executables "${exe}" index)
  if("${index}" EQUAL "-1")
    message("Executable ${exe} not found")
  else()
    get_property(project GLOBAL PROPERTY "CMT_${exe}_PROJECT")
    get_property(package GLOBAL PROPERTY "CMT_${exe}_PACKAGE")
    message ("Executable ${exe} in package ${package} of project ${project}")
  endif()
endfunction()

#---------------------------------------------------------
function(cmt_show_environments)
  message("cmt_show_environments>")
  get_property(environments GLOBAL PROPERTY CMT_ENVIRONMENTS)
  foreach(env IN LISTS environments)
    get_property(type GLOBAL PROPERTY "CMT_ENV_TYPE_${env}")
    get_property(value GLOBAL PROPERTY "CMT_ENV_VALUE_${env}")
    get_property(project GLOBAL PROPERTY "CMT_ENV_PROJECT_${env}")
    get_property(package GLOBAL PROPERTY "CMT_ENV_PACKAGE_${env}")
    message ("Environment ${type} ${env}=${value} in in package ${package} of project ${project}")
  endforeach()
endfunction()

#---------------------------------------------------------
function(cmt_show_environment env)
  message("cmt_show_environment> ${env}")
  get_property(environments GLOBAL PROPERTY CMT_ENVIRONMENTS)
  list(FIND environments "${env}" index)
  if("${index}" EQUAL "-1")
    message("Environment ${env} not found")
  else()
    get_property(type GLOBAL PROPERTY "CMT_ENV_TYPE_${env}")
    get_property(value GLOBAL PROPERTY "CMT_ENV_VALUE_${env}")
    get_property(project GLOBAL PROPERTY "CMT_ENV_PROJECT_${env}")
    get_property(package GLOBAL PROPERTY "CMT_ENV_PACKAGE_${env}")
    message ("Environment ${type} ${env}=${value} in in package ${package} of project ${project}")
  endif()
endfunction()

#---------------------------------------------------------
function(cmt_run command)
  message("cmt_run> ${command}")
  get_property(environments GLOBAL PROPERTY CMT_ENVIRONMENTS)
  foreach(env IN LISTS environments)
    get_property(value GLOBAL PROPERTY "CMT_ENV_VALUE_${env}")
    set($ENV{${env}} "${value}")
  endforeach()
endfunction()

#---------------------------------------------------------
function(cmt_environment name type value)

  cmt_append_unique_property(CMT_ENVIRONMENTS "${name}")
  set_property(GLOBAL PROPERTY "CMT_ENV_TYPE_${name}" "${type}")
  if ("${type}" STREQUAL "PATH_PREPEND")
    get_property(old GLOBAL PROPERTY "CMT_ENV_VALUE_${name}")

    if("${old}" STREQUAL "")
      set(old "$ENV{${name}}")
    endif()

    if("${old}" STREQUAL "")
      set_property(GLOBAL PROPERTY "CMT_ENV_VALUE_${name}" "${value}")
    else()
      set_property(GLOBAL PROPERTY "CMT_ENV_VALUE_${name}" "${value};${old}")
    endif()
  elseif ("${type}" STREQUAL "PATH_APPEND")
    get_property(old GLOBAL PROPERTY "CMT_ENV_VALUE_${name}")

    if("${old}" STREQUAL "")
      set(old "$ENV{${name}}")
    endif()

    if("${old}" STREQUAL "")
      set_property(GLOBAL PROPERTY "CMT_ENV_VALUE_${name}" "${value}")
    else()
      set_property(GLOBAL PROPERTY "CMT_ENV_VALUE_${name}" "${old};${value}")
    endif()
  else()
    set_property(GLOBAL PROPERTY "CMT_ENV_VALUE_${name}" "${value}")
  endif()

  get_property(project GLOBAL PROPERTY CMT_CURRENT_PROJECT)
  get_property(package GLOBAL PROPERTY CMT_CURRENT_PACKAGE)

  set_property(GLOBAL PROPERTY "CMT_ENV_PROJECT_${name}" "${project}")
  set_property(GLOBAL PROPERTY "CMT_ENV_PACKAGE_${name}" "${package}")
endfunction()

#---------------------------------------------------------
function(cmt_path name value)
  cmt_environment(${name} PATH "${value}")
endfunction()

#---------------------------------------------------------
function(cmt_path_prepend name value)
  cmt_environment(${name} PATH_PREPEND "${value}")
endfunction()

#---------------------------------------------------------
function(cmt_path_append name value)
  cmt_environment(${name} PATH_APPEND "${value}")
endfunction()

#---------------------------------------------------------
function(cmt_library name sources link)
  plustab()

  cmt_append_unique_property(CMT_LIBRARIES "${name}")

  get_property(project GLOBAL PROPERTY CMT_CURRENT_PROJECT)
  get_property(package GLOBAL PROPERTY CMT_CURRENT_PACKAGE)

  set_property(GLOBAL PROPERTY "CMT_${name}_PROJECT" "${project}")
  set_property(GLOBAL PROPERTY "CMT_${name}_PACKAGE" "${package}")

  get_directory_property(prop INCLUDE_DIRECTORIES)
  cmt_message("project=${project} lib=${name} prop=${prop}")

  get_property(CMT_${project}_PROJECT_PATH GLOBAL PROPERTY CMT_${project}_PROJECT_PATH)
  cmt_message("add_library(${name} SHARED ${sources})")
  add_library(${name} SHARED ${sources})
  cmt_message("install(TARGETS ${name} DESTINATION ${CMT_${project}_PROJECT_PATH}/installarea)")
  install(TARGETS ${name} DESTINATION ${CMT_${project}_PROJECT_PATH}/installarea)
  if(NOT("${link}" STREQUAL ""))
    cmt_message("target_link_libraries(${name} ${link})")
    target_link_libraries(${name} ${link})
  endif()
  moinstab()
endfunction()

#---------------------------------------------------------
function(cmt_executable name sources link)
  plustab()

  cmt_append_unique_property(CMT_EXECUTABLES "${name}")

  get_property(project GLOBAL PROPERTY CMT_CURRENT_PROJECT)
  get_property(package GLOBAL PROPERTY CMT_CURRENT_PACKAGE)

  set_property(GLOBAL PROPERTY "CMT_${name}_PROJECT" "${project}")
  set_property(GLOBAL PROPERTY "CMT_${name}_PACKAGE" "${package}")

  get_directory_property(prop INCLUDE_DIRECTORIES)
  cmt_message("project=${project} exe=${name} prop=${prop}")

  get_property(CMT_${project}_PROJECT_PATH GLOBAL PROPERTY CMT_${project}_PROJECT_PATH)
  cmt_message("add_executable(${name} ${sources})")
  add_executable(${name} ${sources})
  cmt_message("install(TARGETS ${name} DESTINATION ${CMT_${project}_PROJECT_PATH}/installarea)")
  install(TARGETS ${name} DESTINATION ${CMT_${project}_PROJECT_PATH}/installarea)
  if(NOT("${link}" STREQUAL ""))
    cmt_message("target_link_libraries(${name} ${link})")
    target_link_libraries(${name} ${link})
  endif()
  moinstab()
endfunction()

#---------------------------------------------------------
function(cmt_test name)
  plustab()

  cmt_append_unique_property(CMT_TESTS "${name}")

  get_property(project GLOBAL PROPERTY CMT_CURRENT_PROJECT)
  get_property(package GLOBAL PROPERTY CMT_CURRENT_PACKAGE)

  set_property(GLOBAL PROPERTY "CMT_${name}_PROJECT" "${project}")
  set_property(GLOBAL PROPERTY "CMT_${name}_PACKAGE" "${package}")

  get_property(CMT_${project}_PROJECT_PATH GLOBAL PROPERTY CMT_${project}_PROJECT_PATH)

  cmt_message("project=${project} package=${package} CMT_${project}_PROJECT_PATH=${CMT_${project}_PROJECT_PATH}")

  cmt_message("add_test(NAME ${name} WORKING_DIRECTORY ${CMT_${project}_PROJECT_PATH}/installarea COMMAND ${CMT_${project}_PROJECT_PATH}/installarea/test${package}.exe)")
  add_test(NAME ${name} WORKING_DIRECTORY ${CMT_${project}_PROJECT_PATH}/installarea COMMAND ${CMT_${project}_PROJECT_PATH}/installarea/test${package}.exe)

  moinstab()
endfunction()

#---------------------------------------------------------
function(cmt_use_project name)
  plustab()

  get_property(project GLOBAL PROPERTY CMT_CURRENT_PROJECT)

  get_property(uses_projects GLOBAL PROPERTY CMT_USE_PROJECT)
  list(FIND uses_projects ${name} i)
  if(i EQUAL -1)
    cmt_message("Configuring the new project ${name}")
    # register this new project
    cmt_append_unique_property(CMT_USE_PROJECT "${name}")
  else()
    cmt_message("Project ${name} has been already configured")

    set_property(GLOBAL PROPERTY CMT_CURRENT_PROJECT ${project})

    get_property(CMT_${project}_PROJECT_PATH GLOBAL PROPERTY CMT_${project}_PROJECT_PATH)
    get_property(CMT_${name}_PROJECT_PATH GLOBAL PROPERTY CMT_${name}_PROJECT_PATH)

    cmt_message("set_property(DIRECTORY ${CMT_${project}_PROJECT_PATH} APPEND PROPERTY INCLUDE_DIRECTORIES ${CMT_${name}_PROJECT_PATH}/installarea) ")
    set_property(DIRECTORY ${CMT_${project}_PROJECT_PATH} APPEND PROPERTY INCLUDE_DIRECTORIES ${CMT_${name}_PROJECT_PATH}/installarea) 

    cmt_message("set_property(DIRECTORY ${CMT_${project}_PROJECT_PATH} APPEND PROPERTY LINK_DIRECTORIES ${CMT_${name}_PROJECT_PATH}/installarea) ")
    set_property(DIRECTORY ${CMT_${project}_PROJECT_PATH} APPEND PROPERTY LINK_DIRECTORIES ${CMT_${name}_PROJECT_PATH}/installarea) 

    get_property(prop DIRECTORY ${CMT_${name}_PROJECT_PATH} PROPERTY COMPILE_DEFINITIONS)

    cmt_message("set_property(DIRECTORY ${CMT_${project}_PROJECT_PATH} APPEND PROPERTY COMPILE_DEFINITIONS ${prop}) ")
    set_property(DIRECTORY ${CMT_${project}_PROJECT_PATH} APPEND PROPERTY COMPILE_DEFINITIONS ${prop}) 
  endif()

  if(EXISTS ${CMTPROJECTPATH}/${name})
    if(i EQUAL -1)
      # we have to ensure that a build directory exists for this project
      cmt_message ("file(MAKE_DIRECTORY ${CMTPROJECTPATH}/${name}/build)")
      file(MAKE_DIRECTORY ${CMTPROJECTPATH}/${name}/build)

      # entering this project 
      cmt_message("add_subdirectory(${CMTPROJECTPATH}/${name} ${CMTPROJECTPATH}/${name}/build)")
      add_subdirectory(${CMTPROJECTPATH}/${name} ${CMTPROJECTPATH}/${name}/build)
      cmt_message("after add_subdirectory")

      set_property(GLOBAL PROPERTY CMT_CURRENT_PROJECT ${project})

      get_property(CMT_${project}_PROJECT_PATH GLOBAL PROPERTY CMT_${project}_PROJECT_PATH)
      get_property(CMT_${name}_PROJECT_PATH GLOBAL PROPERTY CMT_${name}_PROJECT_PATH)

      cmt_message("set_property(DIRECTORY ${CMT_${project}_PROJECT_PATH} APPEND PROPERTY INCLUDE_DIRECTORIES ${CMT_${name}_PROJECT_PATH}/installarea) ")
      set_property(DIRECTORY ${CMT_${project}_PROJECT_PATH} APPEND PROPERTY INCLUDE_DIRECTORIES ${CMT_${name}_PROJECT_PATH}/installarea) 

      cmt_message("set_property(DIRECTORY ${CMT_${project}_PROJECT_PATH} APPEND PROPERTY LINK_DIRECTORIES ${CMT_${name}_PROJECT_PATH}/installarea) ")
      set_property(DIRECTORY ${CMT_${project}_PROJECT_PATH} APPEND PROPERTY LINK_DIRECTORIES ${CMT_${name}_PROJECT_PATH}/installarea) 

      get_property(prop DIRECTORY ${CMT_${name}_PROJECT_PATH} PROPERTY COMPILE_DEFINITIONS)

      cmt_message("set_property(DIRECTORY ${CMT_${project}_PROJECT_PATH} APPEND PROPERTY COMPILE_DEFINITIONS ${prop}) ")
      set_property(DIRECTORY ${CMT_${project}_PROJECT_PATH} APPEND PROPERTY COMPILE_DEFINITIONS ${prop}) 
    endif()
  endif()

  moinstab()
endfunction()

#---------------------------------------------------------
function(cmt_use_package name)
  plustab()
  cmt_message("Use Package name=${name}")
  moinstab()
endfunction()

#---------------------------------------------------------
function(cmt_has_package name prefix)
  plustab()

  set(pwd ${CMAKE_CURRENT_SOURCE_DIR})
  cmt_message("cmt_has_package(${name} ${prefix}) pwd=${pwd}")

  cmt_append_unique_property(CMT_PACKAGE "${name}")
  set_property(GLOBAL PROPERTY CMT_${name}_PATH "${pwd}")
  set_property(GLOBAL PROPERTY CMT_${name}_PREFIX "${prefix}")

  if(EXISTS "${pwd}/${prefix}/${name}")

    cmt_message("Package name=${name} prefix=${prefix} found in ${pwd}/${prefix}/${name}")

    set(pname ${prefix}/${name})

    if("${prefix}" STREQUAL "")
      set(pname ${name})
    endif()

    cmt_message("add_subdirectory(${pname}) for package")
    add_subdirectory(${pname})
    cmt_message("after add_subdirectory for package")

  else()

    cmt_message("Package name=${name} prefix=${prefix} not found in ${pwd}/${prefix}/${name}")

  endif()

  moinstab()
endfunction()

function(cmt_init status)
  # default value for tests
  set(CMTSITE LAL)
  set(CMTCONFIG win32)
  set(CMTPROJECTPATH $ENV{CMTROOT}/test)

  if("$ENV{CMTSITE}" STREQUAL "")
    set(ENV{CMTSITE} "${CMTSITE}")
  endif()

  if("$ENV{CMTCONFIG}" STREQUAL "")
    set(ENV{CMTCONFIG} "${CMTCONFIG}")
  endif()

  if("$ENV{CMTPROJECTPATH}" STREQUAL "")
    set(ENV{CMTPROJECTPATH} "${CMTPROJECTPATH}")
  endif()

  cmt_message("---------- Set system env. vars")
  set(tag ${CMAKE_SYSTEM})
  cmt_message("uname=${tag}")
  ###cmt_activate_tag("${tag}")

  set(tag $ENV{CMTSITE})
  cmt_message("CMTSITE=${tag}")
  if(NOT("${tag}" STREQUAL ""))
    ###cmt_activate_tag("${tag}")
  endif()

  set(tag $ENV{CMTCONFIG})
  cmt_message("CMTCONFIG=${tag}")
  if(NOT("${tag}" STREQUAL ""))
    ###cmt_activate_tag("${tag}")
  endif()


  cmt_message("---------- Decoding CMTPROJECTPATH")
  #if(WIN32)
  #  string(REPLACE ":" ";" CMTPROJECTPATH "$ENV{CMTPROJECTPATH}")
  #endif()
  cmt_message("CMTPROJECTPATH=$ENV{CMTPROJECTPATH}")
  set_property(GLOBAL PROPERTY CMTPROJECTPATH $ENV{CMTPROJECTPATH})

  cmt_message("CMTPROJECTPATH=$ENV{CMTPROJECTPATH}")
  foreach(p IN LISTS CMTPROJECTPATH)
    cmt_message("Element of CMTPROJECTPATH = ${p}") 
  endforeach()

  cmt_message("CMAKE_CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR} CMAKE_CURRENT_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}")

  enable_testing()

endfunction()

function(cmt_action)
  cmt_on()

  if("${action}" STREQUAL "show uses")
    ##cmt_show_uses()
  elseif("${action}" MATCHES "show library ")
    string(REPLACE "show library " "" name "${action}")
    cmt_show_library(${name})
  elseif("${action}" STREQUAL "show libraries")
    cmt_show_libraries()
  elseif("${action}" MATCHES "show executable ")
    string(REPLACE "show executable " "" name "${action}")
    cmt_show_executable(${name})
  elseif("${action}" STREQUAL "show executables")
    cmt_show_executables()
  elseif("${action}" STREQUAL "show projects")
    cmt_show_projects()
  elseif("${action}" MATCHES "show project ")
    string(REPLACE "show project " "" name "${action}")
    cmt_show_project(${name})
  elseif("${action}" STREQUAL "show packages")
    cmt_show_packages()
  elseif("${action}" MATCHES "show package ")
    string(REPLACE "show package " "" name "${action}")
    cmt_show_package(${name})
  elseif("${action}" MATCHES "run ")
    string(REPLACE "run " "" command "${action}")
    cmt_run(${command})
  elseif("${action}" STREQUAL "show environments")
    cmt_show_environments()
  elseif("${action}" MATCHES "show environment ")
    string(REPLACE "show environment " "" name "${action}")
    cmt_show_environment(${name})
  endif()

endfunction()

