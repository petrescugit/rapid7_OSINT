#make the file
sort osint_data.txt | uniq -u > osint_data.txt.tmp
mv osint_data.txt.tmp osint_data.txt
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" osint_data.txt > osint_data.txt.tmp
mv osint_data.txt.tmp osint_data.txt

#read the file
while read hostname
do
    IP=$hostname
    REVERSE_IP=$(echo $IP | awk -F "." '{print $4"."$3"."$2"."$1}')
    ASN_INFO=$(dig +short $REVERSE_IP.origin.asn.cymru.com TXT)
    PEER_INFO=$(dig +short $REVERSE_IP.peer.asn.cymru.com TXT)
    NUMBER=$(echo $ASN_INFO | cut -d'|' -f 1 | cut -d'"' -f 2 | cut -d' ' -f 1)
    ASN="AS$NUMBER"
    ASN_REPORT=$(dig +short $ASN.asn.cymru.com TXT)
    SUBNET=$(echo $ASN_INFO | cut -d'|' -f 2)
    COUNTRY=$(echo $ASN_INFO | cut -d'|' -f 3)
    ISSUER=$(echo $ASN_INFO | cut -d'|' -f 4)
    PEERS=$(echo $PEER_INFO | cut -d'|' -f 1 | cut -d'"' -f 2)
    REGISTRY_DATE=$(echo $ASN_REPORT | cut -d'|' -f 4)
    REGISTRANT=$(echo $ASN_REPORT | cut -d'|' -f 5 | cut -d'"' -f 1)

    # Print tab delimited with headers
    #echo "#Query,Subnet,Registrant,AS Number,Country,Issuer,Registry Date,Peer ASNs"
    echo -e "$IP\t$SUBNET\t\t\t\t$REGISTRANT\t$ASN\t$COUNTRY\t$ISSUER" >> osint_WHOIS.txt

done < osint_data.txt