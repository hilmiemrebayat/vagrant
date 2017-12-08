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
3. Daarna controleren we de default gatway. We verwachten voor enp0s3 "10.0.2.2". De default gateway kan je bekijken met de volgende commando: `ip r``. Na het uitvoeren van de commando zien we als uitvoer "default via 10.0.2.2 dev...". Dus de default gateway klopt ook.
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
- Open 192.168.56.in-addr.arpa en controlleer de file met de commando `sudo vi /var/named/2.0.192.in-addr.arpa`. Na het openen ziet men dat er na ....cynalco.com geen punt (.) staat. Hierdoor kan de service ook niet gestart worden. We zetten een punt na elk cynalco.com en we passen ook de getallen voor de hostnaam butterfree en fushigisou aan. We voegen ook tamatama.cyncynalco.com toe onder de primaire dns. De file moet er zo uit zien:
- Na de aanpassingen voeren we de volgende commando's uit om de service te stoppen en te starten: `sudo systemctl stop named` en '`sudo systemctl start named`. De systeem start nu zonder problemen op. We bekijken of er nog fouten zijn met de commando `sudo systemctl status named -l`. Na het uitvoeren zien we dat er geen fouten zijn en dat de service actief is zonder problemen.



### Application Layer


## End result



## Resources

List all sources of useful information that you encountered while completing this assignment: books, manuals, HOWTO's, blog posts, etc.