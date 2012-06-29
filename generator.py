
import os, sys, re, shutil
import random

Letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

#---------------------------------------------------------
def encode(n):
    s=''
    while True:
	k = n % 26
	s = Letters[k] + s
	n = int(n/26) - 1
	if n < 0:
	    break
    return (s)

#---------------------------------------------------------
def write_text (file_name, text):
    try:
	f = open(file_name, 'w')
	f.write (text)
    finally:
	f.close ()


CMTProjects = {}
CMTPackages = {}
    
class CMTPackage:
    #---------------------------------------------------------
    def __init__ (self, mode, project, prefix, package):
	print 'creating the package %s %s' % (package, prefix)
	self.mode = mode
	self.project = project
	self.prefix = prefix
	self.name = package
	self.full_name = os.path.join (prefix, self.name)
	self.path = os.path.join (project, self.full_name)	
	self.uses = {}

    #---------------------------------------------------------
    def cleanup (self):
	print '> rmdir (%s)' % self.path
	if os.path.exists(self.path):
	    shutil.rmtree(self.path)

    #---------------------------------------------------------
    def set_structure (self):
	#print '> mkdir %s' % (self.path)
	#os.mkdir (self.path)

	def create_dirs (path, end = ''):
	    head, tail = os.path.split (path)
	    #print '> (path=%s end=%s) => (head=%s tail=%s)' % (path, end, head, tail)

	    if head != '':
		create_dirs (head, os.path.join (tail, end))
		
	    try:
		print '> mkdir %s' % (path)
		os.mkdir (path)
	    except:
		pass
	    
	create_dirs (self.path)

	# Create the package structure:
	#    <project>/<prefix>/<package>
	#                                /<package>/
	#                                /src/

	#                                /cmt/
	
	print '> mkdir %(path)s/%(package)s' % {'path':self.path, 'package':self.name}
	os.mkdir (os.path.join (self.path, self.name))

	print '> mkdir %(path)s/src' % {'path':self.path}
	os.mkdir (os.path.join (self.path, 'src'))

	print '> mkdir %(path)s/cmt' % {'path':self.path}
	os.mkdir (os.path.join (self.path, 'cmt'))

    #---------------------------------------------------------
    def set_headers (self):

	# print '> create %s/%s/Lib%s.hxx uses=%s' % (self.path, self.name, self.name, self.uses)

	text = '''
#ifndef __Lib%(p)s_hxx__
#define __Lib%(p)s_hxx__
// --------------------------------------
''' % {"p":self.name}
	    
	if len(self.uses) > 0:
	    for u in self.uses:
		text += '#include <%s/Lib%s.hxx>\n' % (u, u)

	text += '''

#ifdef _MSC_VER
#define DllExport __declspec( dllexport )
#else
#define DllExport
#endif


class DllExport C%(p)s
{
public:
    C%(p)s ();
    ~C%(p)s ();
    void f();
private:\n'''  % {"p":self.name}

	if len(self.uses) > 0:
	    for u in self.uses:
		text += '    C%(p)s o%(p)s;\n' % {"p":u}

	text += '''};
// --------------------------------------
#endif

'''

	write_text (os.path.join (self.path, self.name, 'Lib%s.hxx' % self.name), text)

    #---------------------------------------------------------
    def set_sources (self):

	# print '> create %s/src/Lib%s.cxx' % (self.path, self.name)

	text = '''// --------------------------------------
#include <iostream>
#include <%(p)s/Lib%(p)s.hxx>

C%(p)s::C%(p)s ()
{
    std::cout << "Constructor C%(p)s" << std::endl;
}

C%(p)s::~C%(p)s ()
{
    std::cout << "Destructor C%(p)s" << std::endl;
}

void C%(p)s::f ()
{
    std::cout << "C%(p)s.f" << std::endl;\n''' % {"p":self.name}

	if len(self.uses) > 0:
	    for k in self.uses:
		text += '    o%s.f();\n' % (k)

	text += '''}
// --------------------------------------
'''

	write_text (os.path.join (self.path, 'src', 'Lib%s.cxx' % self.name), text)

    #---------------------------------------------------------
    def set_test (self):

	# print '> create %s/src/test%s.cxx' % (self.path, self.name)

	text = '''// --------------------------------------
#include <iostream>
#include <%(p)s/Lib%(p)s.hxx>

int main ()
{
    C%(p)s o;

    o.f ();
}
// --------------------------------------

''' % {"p":self.name}

	write_text (os.path.join (self.path, 'src', 'test%s.cxx' % self.name), text)

    #---------------------------------------------------------
    def set_requirements (self):

	# print '> create %s/cmt/requirements' % (self.path)

	text = '#-----------------\n'
	if len(self.uses) > 0:
	    for u in self.uses:
		p = CMTPackages[u]
		text += 'use %s %s\n' % (u, p.prefix)

	text += 'macro Lib%(p)s_linkopts "%(libs)s"\n' % {"p":self.name,
							  "libs":' '.join (['Lib%s' % u for u in self.uses])}

	text += 'library Lib%(p)s Lib%(p)s.cxx\n' % {"p":self.name}

	text += 'macro test%(p)s_linkopts "%(libs)s"\n' % {"p":self.name,
							   "libs":' '.join (['Lib%s' % u for u in self.uses])}
	text += '''program test%(p)s test%(p)s.cxx
#-----------------''' % {"p":self.name}
	    
	write_text (os.path.join (self.path, 'cmt', 'requirements'), text)

    #---------------------------------------------------------
    def show_uses (self, t=''):
	if t == '':
	    print 'show uses> Package %s' % (self.name)
	for u in set(self.uses):
	    print '%s  use:%s' % (t, u)
	    p = CMTPackages[u]
	    p.show_uses (t + '  ')

    def show_graph (self):
	text = ''
	for u in set(self.uses):
	    text += '%s -> %s\n' % (self.name, u)
	return text

    #---------------------------------------------------------
    def show_all_uses (self):
	print '------------------ show all uses'
	for k in set(CMTPackages.keys()):
	    p = CMTPackages[k]
	    print 'Package:%s' % (k)
	    p.show_uses ()
	print '------------------'

    #---------------------------------------------------------
    def get_uses (self):
	def recurse (package, all):
	    # get complete (recursive) list of used packages
	    for u in set(package.uses):
		#print '(p:%s u:%s uses:%s all:%s)' % (package.name, u, package.uses, all)
		if not (u in all):
		    all.add (u)
		    p = CMTPackages[u]
		    all |= recurse (p, all)
	    return (all)

	all = set()
	if len(self.uses) > 0:
	    all = recurse (self, set())
	    #print 'in get_uses for %s all=%s' % (self.name, all)
	return (all)

    #---------------------------------------------------------
    def set (self):

	print '----------- Set package %s' % (self.name)

	if len(CMTPackages) > 1:
	    # get all packages but self
	    keys = list(CMTPackages.keys())
	    del keys[keys.index(self.name)]

            nuses = len(keys)/2

	    if nuses > 0:
		# select a subset of those

		# we remove recursive uses
		# the list of uses specifies only the first level of uses. Thefore, we need a search function to check
		# if the current package is already in the chain of uses.
		# eg: A use B and B use A
		# if [A use B] was defined first, we need to remove A from the list of uses of B

		uses = set(random.sample (keys, random.choice (range(len(keys)/2))))
		print 'pack> Original all used %s for package %s' % (uses, self.name)

		toberemoved = set()
		for u in uses:
		    p = CMTPackages[u]
		    if self.name in p.get_uses():
			toberemoved.add(u)

		print 'pack> to be removed used %s' % (toberemoved)
		uses -= toberemoved

		# now we have to remove packages that belong to a project which is NOT used by the current project.

		for u in uses:
		    pack = CMTPackages[u]
		    proj = CMTProjects[pack.project]
		    if not ((self.project in proj.get_uses ()) or (self.project == pack.project)):
			toberemoved.add(u)

		print 'pack> to be removed used %s' % (toberemoved)
		uses -= toberemoved
		print 'pack> Final all used %s' % (uses)

		self.uses = uses

		print 'pack> package %s uses = %s' % (self.name, self.uses)

	self.set_headers ()
	self.set_sources ()
	self.set_test ()
	self.set_requirements ()

    #---------------------------------------------------------
    def set_config_file (self):

	# print '> create %s/CMakeLists.txt' % (self.path)

	text = '''
cmake_minimum_required(VERSION 2.8)
include($ENV{CMTROOT}/cmake/CMTLib.cmake)
#-----------------
cmt_package(%(name)s)
''' % { 'name':self.name }

	for u in self.uses:
	    text += '''cmt_use_package (%s)
''' % (u)
	
	text += '''
cmt_library(Lib%(name)s src/Lib%(name)s.cxx "%(uses)s")
cmt_executable(test%(name)s src/test%(name)s.cxx Lib%(name)s)
cmt_test(mytest%(name)s)

#-----------------

cmt_action ()

''' % { 'name':self.name, 'uses':';'.join (['Lib%s' % u for u in self.uses]) }

	write_text (os.path.join (self.path, 'CMakeLists.txt'), text)









class CMTProject:

    #---------------------------------------------------------
    def __init__ (self, mode, name, first_package, packages = 1):
	global Letters
	
	self.mode = mode
	self.name = name
	#self.base = base
	self.packages = []
	self.uses = {}

	for package in range(first_package, first_package + packages):
	    prefix = ''
	    if random.choice (xrange (2)) == 1:
		prefix = os.path.normpath (os.path.join ('Pre', 'Fix'))
		prefix = prefix.replace ('\\', '/')
	    package_name = name + '_' + encode(package)
	    CMTPackages[package_name] = CMTPackage (mode, name, prefix, package_name)
	    self.packages.append(package_name)
	    
    #---------------------------------------------------------
    def get_uses (self):
	def recurse (project, all):
	    # get complete (recursive) list of used projects
	    for u in set(project.uses):
		#print '(p:%s u:%s uses:%s all:%s)' % (project.name, u, project.uses, all)
		if not (u in all):
		    all.add (u)
		    p = CMTProjects[u]
		    all |= recurse (p, all)
	    return (all)

	all = set()
	if len(self.uses) > 0:
	    all = recurse (self, set())
	    #print 'in get_uses for %s all=%s' % (self.name, all)
	return (all)

    #---------------------------------------------------------
    def set (self):
	if len(CMTProjects) > 1:
	    # get all projects but self
	    keys = list(CMTProjects.keys())
	    del keys[keys.index(self.name)]

            nuses = len(keys)/2

	    if nuses > 0:
		# select a subset of those

		# we remove recursive uses
		# the list of uses specifies only the first level of uses. Thefore, we need a search function to check
		# if the current package is already in the chain of uses.
		# eg: A use B and B use A
		# if [A use B] was defined first, we need to remove A from the list of uses of B

		uses = set(random.sample (keys, random.choice (range(len(keys)))))
		print 'Original all used %s for project %s' % (uses, self.name)
		#for u in uses:
		#    p = CMTProjects[u]
		    
		toberemoved = set()
		for u in uses:
		    p = CMTProjects[u]
		    if self.name in p.get_uses():
			toberemoved.add(u)

		print 'to be removed used %s' % (toberemoved)
		uses -= toberemoved
		print 'Final all used %s' % (uses)

		self.uses = uses

		print 'project %s uses = %s' % (self.name, self.uses)


    #---------------------------------------------------------
    def cleanup (self):
	print '> rmdir (%s)' % self.name
	if os.path.exists(self.name):
	    shutil.rmtree(self.name)

    #---------------------------------------------------------
    def set_structure (self):
	print '> mkdir %s' % (self.name)
	os.mkdir (self.name)

	print '> mkdir %s/build' % (self.name)
	os.mkdir (os.path.join (self.name, 'build'))

	print '> mkdir %s/cmt' % (self.name)
	os.mkdir (os.path.join (self.name, 'cmt'))

	for package in self.packages:
	    p = CMTPackages[package]
	    p.set_structure ()

    #---------------------------------------------------------
    def set_packages (self):
	for package in self.packages:
	    p = CMTPackages[package]
	    p.set ()

    #---------------------------------------------------------
    def get_used_projects (self):
	
	# We start by building the uses of this project through the use graph of the packages.
	# but now, the use graph of the projects has been constructed a-priori.
	
	uses = []
	for package in self.packages:
            p = CMTPackages[package]
	    for u in p.uses:
		pu = CMTPackages[u]
		if not(pu.project in uses) and (pu.project != self.name):
		    uses.append (pu.project)
	
	#print 'project %s use projects %s' % (self.name, uses)
	return (uses)

    #---------------------------------------------------------
    def set_config_file (self):

	config_dir = self.name

	# print '> create %s/CMakeLists.txt' % (config_dir)

	text = '''
cmake_minimum_required(VERSION 2.8)
include($ENV{CMTROOT}/cmake/CMTLib.cmake)
#-----------------
cmt_project(%(name)s "")
''' % { 'name':self.name }

	for u in self.get_used_projects():
	    text += '''
cmt_use_project(%s)
''' % (u)

	for package in self.packages:
	    p = CMTPackages[package]
	    text += '''
cmt_has_package(%s "%s")
''' % (package, p.prefix)

	text += '''
#-----------------

cmt_action ()

''' % { 'name':self.name }

	write_text (os.path.join (self.name, 'CMakeLists.txt'), text)

	for package in self.packages:
            p = CMTPackages[package]
	    p.set_config_file ()









    



"""
CMTGenerator

Construct a CMT project with a hierarchy of projects each containing a hierarchy of packages each containing
 - sources of a library (with one C++ class)
 - sources of a test program (which instantiates one object of the class)
 - a cmt requirements file
 - or a CMakeLists.txt

Projects may use other projects.
Packages may use other packages.
For each used package, the package's class includes the used classes, and instantiates one object for each the used classe
      
"""
class CMTGenerator:
    #---------------------------------------------------------
    def __init__ (self, mode = 'cmt2waf', projects = 1, max_packages = 1, uses = []):
	global Letters
	
	self.mode = mode
	self.projects = projects
	self.max_packages = max_packages
	self.uses = uses
	self.used = {}

	first = 0
	for project in range(projects):
	    name = encode(project)
	    packages = random.choice (xrange (self.max_packages)) + 1
	    print 'creating the project %s' % (name)
	    CMTProjects[name] = CMTProject (self.mode, name, first, packages)
	    first += packages

    #---------------------------------------------------------
    def cleanup_projects (self):
	for project in CMTProjects:
            p = CMTProjects[project]
	    p.cleanup()


    #---------------------------------------------------------
    def set_structure (self):
	for project in CMTProjects:
            p = CMTProjects[project]
	    p.set_structure ()

	if os.path.exists('build'):
	    shutil.rmtree('build')

	print '> mkdir build'
	os.mkdir ('build')

	# print '> create CMakeLists.txt'

	text = '''
cmake_minimum_required(VERSION 2.8)
include($ENV{CMTROOT}/cmake/CMTLib.cmake)
cmake_minimum_required(VERSION 2.8)

set(CMTROOT "$ENV{CMTROOT}")
set(CMTPROJECTPATH "$ENV{CMTPROJECTPATH}")
if("${CMTPROJECTPATH}" STREQUAL "")
  set(CMTPROJECTPATH "${CMTROOT}/test")
endif()

unset(status)
cmt_init(status)

if("${status}" STREQUAL "stop")
 return()
endif()

cmt_off()

cmt_use_project(work)

cmt_project(work "")

'''

	for project in CMTProjects:
	    text += '''cmt_use_project(%s)
''' % (project)

	text += '''
cmt_action()

'''


	write_text ('CMakeLists.txt', text)


    #---------------------------------------------------------
    def set (self):
	for project in CMTProjects:
            p = CMTProjects[project]
	    p.set()

	for project in CMTProjects:
            p = CMTProjects[project]
	    p.set_packages()

    #---------------------------------------------------------
    def set_config_files (self):

	for project in CMTProjects:
            p = CMTProjects[project]
	    p.set_config_file ()
    










    #---------------------------------------------------------
    def get_used (self, p):
	used = set ()
	if p in self.used:
	    used = set (self.used[p])
	return used

    #---------------------------------------------------------
    def get_all_used (self, p):

	def recurse (p, all = []):
	    u = self.get_used (p)
	    if not (p - self.base) in range (self.packages): return []
	    t = [p]
	    for sub in u:
		if not sub in t + all:
		    t += recurse (sub, t + all)
	    return t

	all = recurse (p, [])
	return all

	
    #---------------------------------------------------------
    def generate (self):
	self.cleanup_projects ()
	self.set_structure ()
	self.set ()
	self.set_config_files ()



#-------------------------
# Main class holding command interface
#
class CMTInterface:
    #---------------------------------------------------------
    def generate_project (self, projects, max_packages, mode = 'cmake', uses = []):
	here = os.getcwd ()
	
	generator = CMTGenerator (mode, projects, max_packages, uses)
	generator.generate ()

	print "Fin de la generation"
	print "Production du graph des dependances generator.dot"

	text = """digraph G {
node [shape=box]
"""

	for k in set(CMTProjects.keys()):
	    p = CMTProjects[k]
	    text += "%s;\n" % (p.name)
	    for u in p.get_used_projects ():
		text += "%s -> %s;\n" % (p.name, u)

	text += """node [shape=ellipse];
"""

	for k in set(CMTPackages.keys()):
	    p = CMTPackages[k]
	    text += "%s;\n" % (p.name)
	    text += p.show_graph ()

	text += "}\n"

	write_text ("generator.dot", text)

    
Interface = CMTInterface ()


#----------------------------------------------------------------------------------------------------------------------
# Interface to waflib
#----------------------------------------------------------------------------------------------------------------------


if __name__ == "__main__":
    project = 'A'
    mode = 'cmake'
    projects = 1
    packages = 5
    uses = []
    
    if len(sys.argv) > 1:
	for arg in sys.argv:
	    if re.match ('mode=(cmake|waf|cmt2cmake)', arg):
		m = re.match ('cmt2waf=(\d+)', arg)
		mode = m.group(1)
	    elif re.match ('projects=(\d+)', arg):
		m = re.match ('projects=(\d+)', arg)
		projects = int(m.group(1))
	    elif re.match ('packages=(\d+)', arg):
		m = re.match ('packages=(\d+)', arg)
		packages = int(m.group(1))
            elif re.match ('uses=(.+)', arg):
		m = re.match ('uses=(.+)', arg)
		uses = re.split ('\W+', m.group(1))
    else:
	print """
generator.py
  mode=cmake|waf|cmt2cmake
  projects=<n>
  packages=<n>
  uses=<list>
"""

    print 'mode=%s projects=%d packages=%d uses=%s' % ( mode, projects, packages, uses)

    if projects > 0:
	Interface.generate_project (projects, packages, mode)

