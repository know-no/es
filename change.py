import sys

file_path = sys.argv[1]
hostname = sys.argv[2]
process_id =int( sys.argv[3]) 
basepath = sys.argv[4]

#disks = int(sys.argv[5])
http_port =str(int(process_id) + 9200)
tcp_port =str(int(process_id) + 9300)
ismaster = 'false'
sep = '/'
with open(file_path,'r') as f:
    lines = f.readlines()

with open(file_path,'w') as f:
    for line in lines:
        if line.startswith('node.name'):
            line = 'node.name: '+hostname+'_'+str(process_id)+'\n'
        elif line.startswith('node.master'):
            line = 'node.master: '+ismaster+'\n'
        elif line.startswith('path.data: '):
            line = 'path.data: '
            paths = basepath.split(',')
            for p in paths:
                line += p + sep + str( process_id ) + sep + 'search'+sep+'data'+','
     #       for i in range(disks):
      #          tmp = basepath + str(i + 1) +sep+ str( process_id ) + sep +'search'+sep+'data'+','
       #         line += tmp
            line = line[:-1] + '\n'
        elif line.startswith('http.port'):
            line = 'http.port: '+http_port+'\n'
        elif line.startswith('transport.tcp.port'):
            line = 'transport.tcp.port: '+tcp_port+'\n'
        elif line.startswith('network.publish_host'):
            line = 'network.publish_host: '+hostname+'\n'
        f.write(line)


            





