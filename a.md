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
1. Linux toestenbord is ingesteld als QWERTY. Eerst zal ik dat veranderen in AZERTY om geen typfouten te maken. Dit doe je door de volgende commando te geven:
- localectl set-keymap be

### Link Layer
1. Eerst moet je kijken of je verbinding hebt. Geef de volgende commando in voor het controleren:
- ip link
Volgens de uitvoer is enp0s8 niet verbonden. Ik krijg "no carrier..."
2. Hierdoor moeten we eerst en vooral kijken of de kabels aangesloten zijn op het VM. Dit doe je door de instellingen van VM te openen, naar netwerken te gaan en daarna op advanced te klikken. De "Kabel aangesloten" moet normaal gezien aangevinkt staan. Bij adapter 2 was dat niet het geval, dus moest ik het aanvinken.
3. Nadat je de kabel hebt aangelosten voer je opnieuw de commando "ip link" uit en controller je of "No carier..." verdwenen is. Bij mij was dat het geval dus is deze stap succesvol uitgevoerd.

### Network Layer
1. Eerst moet je kijken of er een ip-adres toegekend is, en of ze juist geconfigureerd zijn. We moeten voor de adapter enp0s8 de ip-adres "192.168.56.42" en voor de adapter enp0s3 de ip-adres "10.0.2.15" te zien krijgen. Dit doe je door de volgende commando uit te voeren:
- ip a
Ik krijg voor de twee adapters de volgende ip-adressen te zien:
- enp0s8 is "192.168.56.42". Dus de ip-adres klopt en er is geen fout.
- enp0s3 is "10.0.2.15". Dus de ip-adres klopt en er is geen fout.
2. Daarna controleren we de default gatway. We verwachten voor enp0s3 "10.0.2.2". De default gateway kan je bekijken met de volgende commando:
- ip r
De commando ip r geeft ons de route weer. Na het uitvoeren van de commando zien we als uitvoer "default via 10.0.2.2 dev...". Dus de default gateway klopt ook.
3. Als laatst gaan we de DNS instellingen controleren. We verwachten "10.0.2.3". Om te checken voeren we de volgende commando uit:
- vi /etc/resolv.conf
We krijgen als uitvoer "nameserver: 10.0.2.3". Dus de dns-server klopt.
4. Als laatst gaan we pingen naar de ip-adressen die hierboven staan. De pingen moet normaalgezien lukken.
- 192.168.56.42 ==> Pingen lukt
- 10.0.2.15 ==> pingen lukt
- 10.0.2.2 ==> Pingen lukt
- 10.0.2.3 ==> pingen lukt
### Transport Layer
1. Eerst gaan we controleren of de service van nginx runt. Je moet normaal gezien te zien krijgen dat het runt, dus "active". We controleren de status door de volgende commando uit te voeren:
- sudo systemctl status nginx
Als uitvoer krijgen we "inactive (dead)". Dus er is een probleem met de server.
Dit lossen we op door de volgende stappen uit te voeren:
 a. Server starten, normaal gezien moet het kunnen starten. We proberen het met de volgende commando: "sudo systemctl start nginx". Na het uitvoeren van de commando start de server niet op. Dus er is een andere probleem. Er staat op dat we naar jourcalctl-ex en nginx.service moeten kijken.
 b. We kijken dus naar journalctl-ex. Dit doen we door de commando "sudo journalctl -f -u nginx" uit te voeren. We krijgen een log te zien en als fout zien we dat de bestand "nignx.pem" niet bestaat.
 c. We gaan hierdoor keer naar de map /etc/pki/tls/cets/ kijken zoals de logboek het zegt. Hiervoor voeren we de commando "sudo ls /etc/pki/tls/cets/" uit. We zien dat er een bestand met nginx.pem bestaat. Er is dus een typfout gedaan, dit gaan we aanpassen. Om het aan te passen open je de bestand met de commando "sudo vi /etc/pki/tls/certs/nginx.pem" en sla je het op met de volgende commandoo: ":wq /etc/pki/tls/certs/nigxn.pem"
 d. Nu start je nginx op en het moet normaal gezien succesvol opstarten. Gebruik de commando "sudo systemctl start nginx". Er is geen uitvoer te zien, dus de server is service is succesvol opgestart.
 e. We gaan controleren of het nu echt draait. Het moet normalgezien draaien. Controleer het met de commando  "sudo systemctl status nginx". Als uitvoer krijg ik dat het runt maar de vendor uitgeschakeld is.
 f. We starten de vendor op met de commando "sudo systemctl enable nginx". Als uitvoer krijgen we dat er een symbolische link aangemaakt is. ==> Succesvol uitgevoerd
 g. Daarna voeren we stap d opnieuw uit om te controleren of vendor runt. Na het uitvoeren zien we dat het runt.

 2. Nadat we nginx hebben gecontroleerd, controleren we ook PHP. PHP moet normaalgezien runnen. Dit doen we door de volgende commando uit te voeren: "sudo systemctl status php-fpm". Als uitvoer zien we dat het runt maar vendor uitgeschakeld is. Dit schakelen we in met de commando "sudo systemctl enable php-fpm".

 3. Nu gaan we de poorten controleren met de commando "sudo ss -tlnp". De poorten 80 en 433 moeten normaalgezien open staan. Na het uitvoeren zien we dat poort 443 niet open staat. Dit moeten we openen.
 a. Open hiervoor de bestand nginx.conf met de commando"sudo vi /etc/nginx/nginx.conf" en voeg bij "server { }", "listen 443;" toe en sla op met :wq.
 b. Start nginx opnieuw op zodat alles up te date wordt. Dit doe je met de commando "sudo systemctl restart nginx".
 c. Controleer opnieuw de poorten met de commando "sudo ss-tlnp". We zien dat de poort succesvol is toegevoegd.

 4. Als laatst gaan we de firewall controleren. HTTP en HTTPS services moet open staan, interface moet toegevoegd zijn en poorten moeten open zijn. Controleren doen we met de commando "sudo firewall-cmd --list-all". Na het uitvoeren van de commando zien we dat ze niet open staan. We stellen ze als volgt open:
 a. Voer de volgende commando uit om http en https toe te laten: "sudo firewall-cmd --add-service=https --permanent" en "sudo firewall-cmd --add-service=http --permanent". Als uitvoer hebben we 'Success' gekregen, dus de services zijn nu open.
 b. Voer de volgende commando uit om de interface toe te voegen waardoor de verkeer door zal gaan: "sudo firewall-cmd --add-interface=enp0s8 --permanent". Als uitvoer hebben we 'Success' gekregen, dus de interface is nu toegevoegd.
 c. Open nu de poorten met de volgende commando zodat de verkeer door kan gaan: "sudo firewall-cmd --add-port=80/tcp --permanent" en "sudo firewall-cmd --add-port=443/tcp --permanent".Als uitvoer hebben we 'Success' gekregen, dus de poorten zijn nu open.
 d. Start de firewall opniew op en controlleer het opnieuw met de volgende commando's:
 - sudo systemctl restart firewalld
 - sudo firewall-cmd --list-all
 Je moet de interface, poorten en de services te zien kijgen. Bij mij is dat het geval en is alles succesvol geconfigureerd.

### Application Layer
1. Open de bowser en surf naar https://192.168.56.42. De server moet bereikbaar zijn en je moet "Keep calm and vagrant up" te zien krijgen. Bij mij is de server bereikbaar maar ik zie geen tekst.
## End result
1. Voer de commando sudo ./runbats.sh uit om de test uit te voeren. Volgens de test is alles goed geconfigureerd maar is enkel de tekst op de browser niet te zien.

2. Aan het einde van de opdracht, wanneer de leerkracht is komen kijken naar de server is er een probleem ontstaan bij het runnen van de nginx server. De file werd verwijderd staat er in de log. Normaal gezien werkte het wel. Om de tekst te laten zien op de browser heb ik wat aanpassingen gedaan aan de server en nu is de file niet meer terug te vinden. Hierdoor is er een fout ontstaan. Normaal gezien werkte het wel.




## Resources
1. https://wiki.archlinux.org/index.php/Keyboard_configuration_in_console
2. http://www.codero.com/knowledge-base/content/10/377/en/how-to-manage-firewall-rules-in-centos-7.html
3. https://www.digitalocean.com/community/tutorials/how-to-move-an-nginx-web-root-to-a-new-location-on-ubuntu-16-04
4. https://devops.profitbricks.com/tutorials/install-nginx-on-centos-7/
5. https://www.digitalocean.com/community/tutorials/how-to-move-an-nginx-web-root-to-a-new-location-on-ubuntu-16-04
6. http://www.codero.com/knowledge-base/content/10/377/en/how-to-manage-firewall-rules-in-centos-7.html
 
