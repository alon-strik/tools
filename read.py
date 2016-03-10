import fileinput

fileToSearch='portConfig.conf'
portipToSearch='PORTIP'
portipToReplace='192.168.5.5'
portnumToSearch='portX'
portnumToReplace='port5'

#tempFile = open( fileToSearch, 'r+' )
#
#for line in fileinput.input( fileToSearch ):
#    if textToSearch in line :
#        print('Match Found')
#    else:
#        print('Match Not Found!!')
#    tempFile.write( line.replace( textToSearch, textToReplace ) )
#tempFile.close()

f  = open(fileToSearch, 'r+')
clean  = f.read().replace(portipToSearch, portipToReplace).replace(portnumToSearch, portnumToReplace)
f.write(clean)

