# Enterprise Linux Lab Report - Troubleshooting

- Student name: Hilmi Emre Bayat
- Class/group: TIN-TI-3B (Gent)

## Instructions

- Write a detailed report in the "Report" section below (in Dutch or English)
- Use correct Markdown! Use fenced code blocks for commands and their output, terminal transcripts, ...
- The different phases in the bottom-up troubleshooting process are described in their own subsections (heading of level 3, i.e. starting with `###`) with the name of the phase as title.
- Every step is described in detail:
    - describe what is being tested
    - give the command, including options and arguments, needed to execute the test, or the absolute path to the configuration file to be verified
    - give the expected output of the command or content of the configuration file (only the relevant parts are sufficient!)
    - if the actual output is different from the one expected, explain the cause and describe how you fixed this by giving the exact commands or necessary changes to configuration files
- In the section "End result", describe the final state of the service:
    - copy/paste a transcript of running the acceptance tests
    - describe the result of accessing the service from the host system
    - describe any error messages that still remain

## Report
1. Linux toestenbord is ingesteld als QWERTY. Eerst zal ik dat veranderen in AZERTY om geen typfouten te maken. Dit doe je door de volgende commando te geven:  `localectl set-keymap be`

### Link Layer
1. Open eerst de instelling van de VM en kijk bij adapter 1 en 2 of "Netwerkaart inschakelen" en "kabel aangesloten" aangevinkt staat. Bij mij was dat het geval.
2. Ga naar adapter 2 en kijk of de VM verbonden is met vboxnet0. Ga daarna naar de instellingen van VirtualBox -> netwerken en kijk naar de instellingen van vboxnet0. De ip adres moet ingesteld staan als 192.168.56.42. Bij mij was dat het geval.
### Network Layer
1. Start de VM op en controlleer of de ip-adressen toegekend zijn. Dit doe je met de commando `ip a`. Bij mij was enp0s8 niet up. Met de commando `ifup enp0s8`heb ik geprobeerd het te activeren, maar het is niet gelukt. Er stond dat er nog een host met de zelfde ip adres bestond. Hierna heb ik gekeken naar mijn VirtualBox en er stond een andere VM open. Ik heb alle VM afgezet en vboxnet0 verwijderd en opnieuw aangemaakt met de ip adres 192.168.56.42. Daarna heb ik opnieuw `ifup enp0s8` gedaan en de netwerkkaart was actief.
2. Nadat de netwerkkaart actief werd heb ik opnieuw `ip a` gedaan en de ip-adressen gecontroleerd. De ip adressen klopten.
- enp0s8 is "192.168.56.42". Dus de ip-adres klopt en er is geen fout.
- enp0s3 is "10.0.2.15". Dus de ip-adres klopt en er is geen fout.
3. Daarna controleren we de default gatway. We verwachten voor enp0s3 "10.0.2.2". De default gateway kan je bekijken met de volgende commando: `ip r`. Na het uitvoeren van de commando zien we als uitvoer "default via 10.0.2.2 dev...". Dus de default gateway klopt ook.
4. Nu gaan we de DNS instellingen controleren. We verwachten "10.0.2.3". Om te checken voeren we de volgende commando uit: `vi /etc/resolv.conf `. We krijgen als uitvoer "nameserver: 10.0.2.3". Dus de dns-server klopt.
5. Als laatst gaan we pingen naar de ip-adres 192.168.56.42 vanuit de terminal van mijn computer.
 - 192.168.56.42 ==> Pingen lukt


### Transport Layer
1. Eerst controleren we of bind actief is. Dit doen we met de commando `service bind status`.  Als uitvoer krijgen we "Active : failed.... code exited, status=1/FAILURE ". Dus er is een probleem met de server. Dit lossen we als volgt op:
- We proberen eerst de service te starten. Dit doen we met de commando `sudo systemctl start named`. Het is niet gelukt. Er is dus een andere probleem. Er staat op dat we naar jourcalctl-ex  moeten kijken.
- We kijken naar de log. Dit doen we met de commando
- Open cynalco.conf met de commando `sudo vi /var/named/cynalco.conf`  en controleer de DNS instellingen. Er was een fout met de ip-adres en er werd geen CNAME toegevoegd voor één server. De volgende zijn veranderd:
  - ip adres van butterfree van 192.168.56.13 naar 192.168.56.12
  - ip adres van beedle van 192.168.56.12 naar 192.168.56.13
  - CNAME toegevoegd mankey. De volgende voeg je toe onder de regel mankey: `files IN CNAME mankey`
  - Open 2.0.192.in-addr.arpa en controlleer de file met de commando `sudo vi /var/named/2.0.192.in-addr.arpa`. Na het openen ziet men dat er na ....cynalco.com geen punt (.) staat. Hierdoor kan de service ook niet gestart worden. We zetten een punt na elk cynalco.com. en we voegen ook tamatama.cyncynalco.com toe onder de primaire dns. De file moet er zo uitzien:
```
  ; Reverse zone file for cynalco.com
  ; Ansible managed: /home/bert/CfgMgmt/troubleshooting/dns/ansible/roles/bertvv.bind/templates/reverse_zone.j2 modified on 2015-06-14 21:02:59 by bert on jace.asgard.lan
  ; vi: ft=bindzone
  
  $TTL 1W
  $ORIGIN 2.0.192.in-addr.arpa.
  
  @ IN SOA golbat.cynalco.com. hostmaster.cynalco.com. (
  15081921
  1D
  1H
  1W
  1D )
  
  IN  NS     golbat.cynalco.com.
  IN  NS     tamatama.cynalco.com.
  2        IN  PTR  tamatama.cynalco.com.
  4        IN  PTR  karakara.cynalco.com.
  6        IN  PTR  sawamular.cynalco.com.
  ~
  ~
  "/var/named/2.0.192.in-addr.arpa" 19L, 579C
```
- Open 192.168.56.in-addr.arpa en controlleer de file met de commando `sudo vi /var/named/2.0.192.in-addr.arpa`. Na het openen ziet men dat er na ....cynalco.com geen punt (.) staat. Hierdoor kan de service ook niet gestart worden. We zetten een punt na elk cynalco.com en we passen ook de getallen voor de hostnaam butterfree en fushigisou aan. We voegen ook tamatama.cyncynalco.com toe onder de primaire dns. De file moet er zo uit zien:
```
; Reverse zone file for cynalco.com
; Ansible managed: /home/bert/CfgMgmt/troubleshooting/dns/ansible/roles/bertvv.bind/templates/reverse_zone.j2 modified on 2015-06-14 21:02:59 by bert on jace.asgard.lan
; vi: ft=bindzone

$TTL 1W
$ORIGIN 2.0.192.in-addr.arpa.

@ IN SOA golbat.cynalco.com. hostmaster.cynalco.com. (
15081921
1D
1H
1W
1D )

IN  NS     golbat.cynalco.com.
IN  NS     tamatama.cynalco.com.
2        IN  PTR  tamatama.cynalco.com.
4        IN  PTR  karakara.cynalco.com.
6        IN  PTR  sawamular.cynalco.com.
~
~
"/var/named/2.0.192.in-addr.arpa" 19L, 579C
```
- Na de aanpassingen voeren we de volgende commando's uit om de service te stoppen en te starten: `sudo systemctl stop named` en '`sudo systemctl start named`. De systeem start nu zonder problemen op. We bekijken of er nog fouten zijn met de commando `sudo systemctl status named -l`. Na het uitvoeren zien we dat er geen fouten zijn en dat de service actief is zonder problemen.
2. Nadat we de service hebben gecontroleerd gaan we enkele testen uitvoeren:
 - We gaan de syntax van configuratiebestanden testen.  We gebruiken hiervoor de commando: `$ sudo named-checkconf /etc/named.conf`. We krijgen geen uitvoer dus er is geen fout.
 - Daarna gaan we de syntax testen van zonebestanden met de commando: `sudo named-checkzone cynalco.com /var/named/cynalco.com`. We krijgen als uitvoer: `zone cynalco.com/IN: loaded serial 15081921. OK`. Dus de syntax is hier ook goed.
 - Hierna gaan we kijken of er fouten zijn door de log te bekijken. Dit doen we door deze twee commando's uit te voeren: `sudo rndc querylog on` en `sudo journalctl -l -f -u named.service`. Als uitvoer krijgen we de volgende zien, dus er ziet ernaar uit dat er geen fout is:
```
 [vagrant@golbat ~]$ sudo journalctl -l -f -u named.service
 -- Logs begin at vr 2017-12-08 08:36:59 UTC. --
 dec 08 10:11:32 golbat.cynalco.com named[3232]: zone cynalco.com/IN: loaded serial 15081921
 dec 08 10:11:32 golbat.cynalco.com named[3232]: zone localhost.localdomain/IN: loaded serial 0
 dec 08 10:11:32 golbat.cynalco.com named[3232]: all zones loaded
 dec 08 10:11:32 golbat.cynalco.com named[3232]: running
 dec 08 10:11:32 golbat.cynalco.com systemd[1]: Started Berkeley Internet Name Domain (DNS).
 dec 08 10:11:32 golbat.cynalco.com named[3232]: zone 192.168.56.in-addr.arpa/IN: sending notifies (serial 15081921)
 dec 08 10:11:32 golbat.cynalco.com named[3232]: zone cynalco.com/IN: sending notifies (serial 15081921)
 dec 08 10:11:32 golbat.cynalco.com named[3232]: zone 2.0.192.in-addr.arpa/IN: sending notifies (serial 15081921)
 dec 08 10:23:10 golbat.cynalco.com named[3232]: received control channel command 'querylog on'
 dec 08 10:23:10 golbat.cynalco.com named[3232]: query logging is now on
```
- Nu gaan we nslookup en een dig uitvoeren naar hogent. Dit doen we met de commando `nslookup www.hogent.be` en `dig www.hogent.be`. We zien als uitvoer: 
```
[vagrant@golbat ~]$ nslookup www.hogent.be
Server:		10.0.2.3
Address:	10.0.2.3#53

Name:	www.hogent.be
Address: 178.62.144.90
```
en
```
[vagrant@golbat ~]$ dig www.hogent.be

; <<>> DiG 9.9.4-RedHat-9.9.4-18.el7_1.3 <<>> www.hogent.be
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 26818
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 5

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.hogent.be.			IN	A

;; ANSWER SECTION:
www.hogent.be.		3600	IN	A	178.62.144.90

;; AUTHORITY SECTION:
hogent.be.		3600	IN	NS	ns2.hogent.be.
hogent.be.		3600	IN	NS	ns1.hogent.be.

;; ADDITIONAL SECTION:
ns1.hogent.be.		3600	IN	A	193.190.173.1
ns1.hogent.be.		3600	IN	AAAA	2001:6a8:1c60:ab00::1
ns2.hogent.be.		3600	IN	A	193.190.173.2
ns2.hogent.be.		3600	IN	AAAA	2001:6a8:1c60:ab00::2

;; Query time: 54 msec
;; SERVER: 10.0.2.3#53(10.0.2.3)
;; WHEN: vr dec 08 10:58:04 UTC 2017
;; MSG SIZE  rcvd: 182

```
Dus nslookup en dig lukt
### Application Layer

Qua applicatie laag kan er niet veel getoond en getest worden.

Vergeten toe te voegen in de stappen. In de file named.conf onderaan heb ik 192.168.56.in-addr.arpa aangepast naar 
56.168.192.in-addr.arpa. De naam van de file 192.168.56.in-addr.arpa in /var/named/ heb ik ook aangepast naar 56.168.192.in-addr.arpa
## End result
1. Pingen naar de ip-adres 192.168.56.42 lukt: 
```
MacBook-Pro-van-Hilmi:~ hilmiemrebayat$ ping 192.168.56.42
PING 192.168.56.42 (192.168.56.42): 56 data bytes
64 bytes from 192.168.56.42: icmp_seq=0 ttl=64 time=0.442 ms
64 bytes from 192.168.56.42: icmp_seq=1 ttl=64 time=0.706 ms
64 bytes from 192.168.56.42: icmp_seq=2 ttl=64 time=0.709 ms
^C
--- 192.168.56.42 ping statistics ---
3 packets transmitted, 3 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 0.442/0.619/0.709/0.125 ms
MacBook-Pro-van-Hilmi:~ hilmiemrebayat$ 
```
2. Test slaagt niet
![Test](https://github.com/hilmiemrebayat/Linux-report/blob/master/Test.jpeg)
3. De service draait:
![Service actief](https://github.com/hilmiemrebayat/Linux-report/blob/master/actief.jpeg)


## Resources

1. https://chamilo.hogent.be/Chamilo/Libraries/Resources/Javascript/Plugin/PDFJS/web/viewer.html?file=https%3A%2F%2Fchamilo.hogent.be%2Findex.php%3Fapplication%3DChamilo%255CCore%255CRepository%26go%3DDocumentDownloader%26object%3D2871660%26security_code%3Db3c37ca8668dbc33f7766314082885441bad55a6%26display%3D1%26saveName%3Dsyllabus-elnx.pdf
2. https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/networking_guide/ch-dns_servers
3. https://github.com/bertvv/ansible-role-bind/#running-vagrant-tests
4. https://www.cyberciti.biz/tips/troubleshooting-bind-dns-2.html
5. https://www.centos.org/docs/5/html/Deployment_Guide-en-US/s1-bind-namedconf.html
6. http://www.itzgeek.com/how-tos/linux/centos-how-tos/how-to-configure-static-ip-address-in-centos-7-rhel-7-fedora-26.html
