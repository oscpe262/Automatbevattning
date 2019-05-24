# Automatiserad bevattning

As the audience at this point is expected to be Swedish, I've chosen to present it in Swedish.
Should you not speak Swedish, and wish for some specifics which can't be figured out from Google Translate or such, feel free to contact me and I will be happy to take those parts in English.

## Inledning 
Det talas i många nördiga kretsar idag om "det smarta hemmet" och automatisering.
Jag har länge haft tankar kring konceptet "smarta hem", och lever (bland annat) på att automatisera saker, vilket den som skummar genom mina repon lätt kan se.

När jag således började tröttna lite på de chilisorter matbutikerna saluför, och tog upp chiliodling som hobby, såg jag min chans att kompensera för mina bristfälligt gröna fingrar med det jag är bra på: datorteknik.

Min chiliodling består i skrivande stund av 18 olika chilisorter, vissa nysådda och vissa färdiga att börja ge frukt inom en snar framtid. Det är ett under att plantstackarna överlevt så långt som de gjort, men ja ... nu har jag ett problem mindre att fundera på, nämligen bevattningen.

Att bo i hyreslägenhet har sina för och nackdelar. Nackdelarna är givetvis begränsad yta utomhus (särskilt när man som jag bor på fjärde våningen)
och att vattentillgången är begränsad till handfat, diskbänk, dusch och toalett. Likaså att jag inte kan göra vilka ingrepp som helst.
Detta innebär för min del att jag blev tvungen att ha en lösning utan rinnande vatten ända fram till plantorna, så en tank var ett måste. 
En tank innebär även pumpar eller hög placering. Hög placering var inte ett alternativ, inte minst eftersom läckagerisken inte är värd att ta.

## Kravställning
Bevattningen skall vara:
- skalbar upp till den mängd plantor som ryms i mitt växthus (cirkus ett trettiotal).
- automatiserad till den grad att jag (efter intrimning) endast behöver ha koll på mängden vatten i tanken.
- utbyggningsbar till att kunna övervakas på distans, såväl gällande funktion som data från godtyckliga sensorer.
- kompakt. Lösningen skall ta såpass liten plats att antalet plantor på given yta endast marginellt behöver minskas.

## Hårdvara
Beskrivning, (Inköpsställe, pris inkl. frakt)
- Skärbräda LEGITIM (IKEA, 20 SEK)
- Låda + lock SAMLA (IKEA, 35 SEK)
- SANPU CPS50-W1V12 12V DC Power Supply 60W 5A (Amazon 177 SEK)
- 4 x Mini fountain pump, UEETEK Submersible Pump DC12V (Amazon SEK 304)
- Blumat matarslang 8mm, droppslang 3mm, T-kopplingar samt ändplugg (hydrogarden.se, metervara, kopplingar 9 SEK/st)
- Raspberry Pi 3B (Någonstans, hades sedan tidigare)
- PiRelay Expansion board for RPI (Amazon, £12.49)
- Diverse skruv, brickor, muttrar, kablage, lödtenn och kabelskor. (Kjell & Co, okänt pris)

## Konstruktion



## Mjukvara
Då jag är \*nixadmin till yrket föll det sig naturligt att nyttja ett enkelt shellscript till att styra reläerna, vilket i sin tur kan schemaläggas i cron.

Distributionen föll naturligt på Raspbian då den kommer med väl utvalda verktyg för just Raspberry Pi. Även om jag inte är en stor fan av Debian så får jag ge att i det här sammanhanget så är det den kanske bäst lämpade disten.

### Scripten
Funktionaliteten inlednindsvis styrs av ett script vilket åkallar ett script vilket har ett stödscript med några enkla funktioner

#### pump.sh
Detta script gör först och främst ett par koller så att vi åkallar det korrekt. Jag har satt en limit på 0-31 sekunders pumptid för att undvika att man matar in längre tider av misstag och då råka pumpa ut hela tanken och dränka plantor och golv.

Syntaxen är exempelvis (för 22 sekunders pumpning på pump 3):

 pump.sh 3 22

Scriptet åkallar pinout.sh (default är att det läggs i roots hemkatalog) och sätter aktuell pin till `hög` (1), väntar pumptiden ut, och sätter sedan genom samma script aktuell pin till `låg` (0).

#### pinout.sh
Exporterar pin vid behov via funktion i `pinbase.sh` och sätter sedan aktuell pin till utgående, och aktiverar/deaktiverar till sist denna pin.

#### pinbase.sh
Erbjuder stödfunktioner för exportering av pin och riktning (in/ut). In används inte för närvarande, men kan komma att användas senare vid läsning av sensorer.

### crontab
Aktuell crontab (`# crontab -e`) gör följande:
Rad 1: Klockan 18:00 varje jämn dag (märk väl att detta ej är varannan dag i månader med 31/29 dagar) alla månader, oavsett veckodag, kör pump 1 i 30 sekunder utan textoutput.
Rad 2: Klockan 18:01 varje dag, kör pump 2 i 30 sekunder.

 0 18 \*/2 \* \* /root/pump.sh 1 30 >/dev/null 2>&1
 0 18 \* \* \* /root/pump.sh 2 30 >/dev/null 2>&1

## Sammanfattning
De värden som används här är initiala körningsvärden specifikt för de pumpar och antal krukor jag använder. Innan du börjar bevattna bör du provköra systemet och mäta upp flödeshastigheter för just dina pumpar.

Den kod som du finner här står dig fritt att använda som du behagar. Jag uppskattar givetvis feedback på den och hoppas att du delar med dig av eventuella förbättringar.
