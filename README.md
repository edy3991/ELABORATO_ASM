Laboratorio di Reti Logiche e Calcolatori Elettronici 
Elaborato di Calcolatori Elettronici: Assembly 
A.A. 2024/2025 
Specifiche: 
si scriva un software in Assembly x86 con sintassi At&t che gestisce i voti ottenuti agli esami degli 
studenti iscritti ad un corso di Laurea. Ogni studente è identificato da una matricola, un nome ed un 
cognome. Ogni esame è caratterizzato da un codice identificativo ed un numero di crediti. 
Il programma dovrà manipolare i seguenti file: - 
anagrafica.txt: contiene la lista di tutti gli studenti iscritti ed il loro numero di matricola. Per 
ogni studente, il file conterrà una riga composta da matricola:nome cognome.  
Ad esempio, per lo studente Mario Rossi, matricola VR123456, il file conterrà la riga: 
VR123456:Mario Rossi - - 
libretti.txt: contiene, per ogni studente, la lista dei voti verbalizzati indicando numero di 
crediti e voto ottenuto. Per ogni studente, il file contiene la matricola, seguita dalle triplette 
codice:crediti:voto, separate da punto e virgola.  
Ad esempio, per lo studente VR123456 che ha superato l’esame con codice ABC da 6 crediti con 
voto 30 e l’esame con codice EFG da 10 crediti con voto 28, la riga corrispondente nel file sarà: 
VR123456 ABC:6:30;EFG:10:28 
La matricola è separata dalla lista dei voti da uno spazio bianco. 
Multipli file di registro esame: potranno aver nome variabile, conterranno nella prima riga il 
codice dell’esame, il numero di crediti ed il numero di studenti che hanno superato l’esame; i 
campi saranno divisi dal simbolo “:”. Successivamente, conterrà i voti degli studenti che hanno 
superato l’esame, uno per riga, indicando la coppia: matricola:voto 
Ad esempio, nel caso dell’esame con codice ABC, da 6 crediti, superato da due studenti, il file 
sarà come segue: 
ABC:6:2 
VR123456:30 
VR789012:18 
I file anagrafica.txt e libretti.txt dovranno essere contenuti in una cartella data/, contenuta nella cartella 
radice del progetto. 
L’eseguibile si dovrà chiamare appelli, e potrà essere lanciato in due modalità: - 
Modalità caricamento: il programma prenderà un parametro che indica il percorso di un file 
contenente il registro di un esame. Il percorso al file contenente il registro dell’esame dovrà essere 
espresso secondo le regole dei percorsi relativi ed assoluti previste dai sistemi operativi Unix, 
quali Linux. Dunque, il comando da utilizzare sarà il seguente: 
$> bin/appelli <path al file di registro da caricare> 
Il programma caricherà l’anagrafica, il file dei libretti, il registro dell’esame. Dopodichè, 
aggiornerà il file dei libretti, aggiungendo i voti contenuti nel file di registro caricato. 
È possible assumere che l’eseguibile venga sempre richiamato dalla cartella radice del progetto, 
ossia la cartella che contiene le cartelle bin, obj, src e data, oltre che il Makefile. 
La procedura dovrà sovrascrivere il file libretti.txt con la sua versione aggiornata. Inoltre, 
dovrà verificare che gli studenti contenuti nel file registro siano effettivamente presenti in 
anagrafica. In caso di errori, si stampino a video gli opportuni messaggi. 
Facoltativo per tutti: è possibile aggiungere un controllo che verifichi che lo studente non abbia 
già effettuato l’esame. Nel caso in cui lo studente abbia già superato l’esame, è possibile decidere 
una politica: sovrascrittura del voto, scelta del voto più alto tra quello contenuto nel file dei libretti 
e quello nel file registro, mantenimento del vecchio voto e stampa a video di un messaggio di 
errore. - 
Modalità interrogazione: qualora il programma venisse lanciato senza alcun parametro, dovrà 
essere eseguita la modalità di interrogazione. Questa permette di visualizzare le informazioni 
relative agli studenti. In particolare, quando il programma viene lanciato con la seguente linea di 
comando: 
$> bin/appelli 
Questo dovrà stampare a video un menu di scelta che prevederà le seguenti azioni: 
1. Esci: termina il programma. 
2. Vedi libretto studente: chiederà di inserire in input il numero di matricola di uno 
studente. Se lo studente è presente in anagrafica stamperà a video il nome e cognome dello 
studente, la lista degli esami sostenuti (codice, crediti e voto ottenuto), la media aritmetica 
e la media ponderata dei voti ottenuti. Nel caso lo studente non sia presente in anagrafica, 
stamperà un messaggio di errore. 
3. Vedi esiti esame: chiederà di inserire in input il codice di un esame. Stamperà a video la 
media dei voti ottenuti da tutti gli studenti in quell’esame. Nel caso l’esame non sia stato 
sostenuto da nessun studente, stamperà un messaggio di avviso. 
Dopo l’esecuzione delle voci 2 e 3, il programma dovrà tornare al menu principale. 
Requisito obbligatorio per i gruppi composti da 3 studenti (facoltativo per i gruppi composti da 2 
studenti): si aggiunga una voce al menu:  
4. Vedi graduatoria: calcola la media ponderata di ciascuna matricola, stampa a video tutti 
gli studenti riportando il numero di matricola, nome, cognome e la media ponderata, 
ordinando gli studenti in base alla media (partendo dallo studente con la media più alta). 
Nel caso in cui due studenti abbiano la stessa media, si dovrà preferire lo studente che ha 
ottenuto un numero di crediti maggiore tra i due. Dopodichè, torna al menu principale. 
Attenzione: tutte le medie andranno calcolate come valori interi, approssimando sempre all’intero 
precedente, ossia per difetto. 
Il programma dovrà effettuare tutti i controlli atti a garantire la consistenza dei file e dovrà segnalare 
all’utente gli eventuali problemi, prevedendo un numero adeguato di messaggi di errore o avviso. 
Materiale da consegnare 
La struttura della cartella dovrà essere la seguente, pena la non ammissibilità dell’elaborato: 
• VRXXXXXX_VRXXXXXX/ 
o src/ 
o obj/ (vuota) 
o bin/ (vuota) 
o Makefile 
o data/ 
▪ anagrafica.txt 
▪ libretti.txt 
▪ vari file di registro 
o Relazione.pdf 
La cartella src dovrà contenere tutto il codice sorgente (assembly), il Makefile dovrà creare i file oggetto 
in obj/ ed il binario che verrà salvato nella cartella bin. La cartella data/ dovrà contenere: 
• Il file anagrafica.txt inizializzato con almeno 5 studenti; 
• Il file libretti.txt inizializzato con almeno 4 studenti che abbiano sostenuto almeno 2 esami; 
• Un numero di file registro adeguato a mostrare tutte le funzionalità del programma in sede di 
esame orale. 
Relazione in formato pdf denominata Relazione.pdf1. La relazione deve essere una breve 
presentazione con massimo 8 slide, compresa la copertina. In copertina deve riportare il numero di 
matricola, nome e cognome di tutti gli studenti del gruppo. La relazione deve spiegare i seguenti punti: 
a. L’organizzazione generale del codice e delle sue funzionalità; 
b. L’organizzazione della memoria, ossia come il programma gestisce i dati in memoria 
centrale; 
c. La gestione dei file, la loro apertura, chiusura e modifica; 
d. Le scelte progettuali fatte e le eventuali interpretazioni ed assunzioni; 
e. L’organizzazione del lavoro e la suddivisione dei compiti tra studenti nel gruppo. 
Modalità di consegna: 
Tutto il materiale va consegnato elettronicamente tramite procedura guidata sul sito Moodle del corso. 
Sarà attivata un’apposita sezione denominata “ASM: <mese> <anno> (scadenza <data>)”. 
L’elaborato deve essere svolto e consegnato da un gruppo formato da 2 o 3 studenti. Non è possibile 
consegnare il progetto individualmente e non è possibile consegnare il progetto in più di tre studenti. Nel 
caso ci fossero difficoltà nel formare il gruppo per lo svolgimento del progetto, su Moodle è disponibile 
un forum apposito. 
La consegna può avvenire (esclusivamente) via Moodle. Ad ogni sessione, i gruppi dovranno registrare 
il proprio interesse a consegnare nella sessione. Una volta registrato il gruppo, i membri del gruppo 
potranno caricare il file contenente il progetto. 
Il codice e la relazione vanno compressi in un unico file tarball denominato: 
VRXXXXXX_VRYYYYYY.tar.gz 
Dove VRXXXXXX e VRYYYYYY rappresenta le matricole degli studenti che compongono il gruppo. 
Nel caso il gruppo sia composto da 3 studenti, comparirà sempre anche una terza matricola VRZZZZZZ. 
Il pacchetto tarball deve contenere un’unica cartella denominata VRXXXXXX_VRYYYYYY, organizzata 
come descritto sopra. 
Verranno accettati solo i progetti compressi in formato tarball (.tar.gz). Per ottenere il pacchetto: 
1. Rinominare la cartella contenente tutto il materiale con il nome VRXXXXXX_VRYYYYYY. 
2. Salire di un livello rispetto alla cartella e lanciare il comando: 
$> tar cvfz VRXXXXXX_VRYYYYYY.tar.gz VRXXXXXX_VRYYYYYY/ 
Ad esempio, se il gruppo è formato da tre studenti con matricole VR123456, VR654321 e VR789012, 
bisogna ottenere il file VR123456_VR654321_vr789012.tar.gz, contenente la cartella 
VR123456_VR654321_vr789012, mediante il comando:  
tar czfv VR123456_VR654321_vr789012.tar.gz VR123456_VR654321_vr789012/ 
1Se fatta in powerpoint, keynote o simili, la presentazione deve essere poi esportata in PDF. File diversi da PDF non verranno accettati. 
Date importanti: 
Sessione di giugno (max. 4 punti per ASM, max. 3 punti per Sis/Verilog) 
Scadenza ultima per la comunicazione dei gruppi: 
Scadenza per la consegna dei progetti su Moodle: 
Pubblicazione del calendario degli orali (su Moodle): 
Periodo (indicativo) degli esami orali: 
8 Giugno 2025 
22 Giugno 2025, ore 23:59:59 
24 Giugno 2025 
30 Giugno – 4 Luglio 2025 
Sessione di Luglio (max. 3 punti per ASM e Sis/Verilog) 
Scadenza ultima per la comunicazione dei gruppi: 
Scadenza per la consegna dei progetti su Moodle: 
Pubblicazione del calendario degli orali (su Moodle): 
Periodo (indicativo) degli esami orali: 
10 Luglio 2025 
24 Luglio 2025, ore 23:59:59 
25 Luglio 2025 
29 – 31 Luglio 2025* 
* nota: eventuali gruppi che necessitassero di sostenere l’orale in anticipo rispetto alle date riportate, 
devono richiederlo almeno 14 giorni prima la data entro cui intendono svolgere l’orale.  
Registrazione dei gruppi alla sessione d’esame: 
La consegna dell’elaborato sarà possibile solamente ai gruppi abilitati su Moodle per la specifica 
sessione. I gruppi devono essere abilitati sulla piattaforma dal docente. Ad ogni sessione, entro 14 giorni 
prima della scadenza per la consegna del progetto, ogni gruppo dovrà comunicare al docente la propria 
composizione. Successivamente, il docente provvederà a creare il gruppo ed abilitarlo alla consegna. 
La comunicazione della composizione del gruppo dovrà avvenire via email. L’email dovrà essere inviata 
a 
michele.lora@univr.it dall’email istituzionale di uno dei componenti del gruppo. Dovranno 
obbligatoriamente essere aggiunti in CC all’email anche: 
• TUTTI i componenti del gruppo (email istituzionali); 
• I due tutor del corso: pietro.turco@univr.it e francesco.biondani_02@univr.it 
L’email dovrà avere il seguente oggetto: asm: VRXXXXXX VRYYYYYY  
Dove VRXXXXXX, VRYYYYYY (ed eventualmente VRZZZZZZ) sono le matricole degli studenti 
facenti parte del gruppo. Nel testo dell’email dovranno essere presenti i dati di tutti i membri del gruppo 
(nome, cognome e matricola), e la richiesta di creare il gruppo. 
Nel caso di modifiche ai gruppi (possibili solo fino a 14 giorni prima della consegna dei progetti), queste 
dovranno essere comunicate con le stesse modalità con cui viene richiesta la creazione del gruppo. 
Entro una settimana dalla richiesta, il docente o i tutor vi confermeranno la presa in carico della richiesta. 
ATTENZIONE: Qualsiasi comunicazione riguardante il gruppo ed il progetto svolto in gruppo dovrà 
avere in CC tutti i componenti del gruppo, altrimenti l’email verrà ignorata. 
Note importanti: 
1. È possibile effettuare più sottomissioni, ma ogni nuova sottomissione cancella quella precedente. 
2. Tutti i componenti del gruppo devono essere iscritti alla pagina Moodle del corso. 
3. Non si accettano progetti consegnati via email e/o dopo la scadenza. 
4. I progetti che non soddisfano i requisiti sopraelencati non verranno ammessi all’orale. 
5. Tutti i progetti verranno testati automaticamente. Solo i progetti che superano i test saranno 
ammessi alla discussione orale. Per valutare l’ammissione all’orale, verranno valutate: 
a. La struttura dell’archivio consegnato, e delle cartelle contenute (check automatico); 
b. La relazione, e la presenza di tutte le informazioni minime richieste (semi-automatico); 
c. Compilazione utilizzando make (automatico); 
d. Esecuzione (semi-automatico); 
6. I progetti non ammessi potranno essere visionati dopo la conclusione delle sessione d’esame. 
7. Qualsiasi chiarimento relativo al testo dell’elaborato, i suoi requisiti o le modalità di consegna, 
dovrà essere richiesto attraverso il forum “Chiarimenti sugli elaborati” disponibile su Moodle, 
seguendo le regole descritte nella pagina principale del forum. 
8. All’orale, tutti gli studenti devono conoscere sufficientemente sia il linguaggio Assembly che il 
progetto, oltre ad essere in grado di utilizzare autonomamente la console di Linux ed i comandi 
necessari. 
