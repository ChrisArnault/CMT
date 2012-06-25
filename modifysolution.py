
import sys, string, glob, re

def main():
    n = len (sys.argv)

    if n < 2:
        print "Give the name of the file to convert"
        sys.exit()

    if n < 3:
        print "Give the name of the file to write"
        sys.exit()

    file_name = sys.argv[1]
    f = open (file_name, "r")
    lines = f.readlines()
    f.close()

    file_name = sys.argv[2]
    f = open (file_name, "w")

    id = ''

    for line in lines:
        n = n + 1
        ##line = string.strip (line, '\n')

	f.write('%s' % (line))

        if re.search(r'INSTALL.vcproj', line):
	    m = re.search (r'[{]([^}]*)[}]["]$', line)
	    id = m.groups()
	    print 'INSTALL found [%s] [%s]' % (id, line)

	if re.search(r'[{]%s[}][.]' % (id), line):
	    print 'def found [%s]' % (line)
	    line = re.sub (r'ActiveCfg', r'Build.0', line)
	    f.write('%s' % (line))
	    


    f.close()

if __name__ == "__main__":
    main()

