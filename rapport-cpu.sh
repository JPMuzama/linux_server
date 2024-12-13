#!/bin/bash
# Récupérer les informations du système
cpu_info=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" |
awk '{print 100 - $1"%"}')
ram_info=$(free -m | awk 'NR==2{printf "Usage de la RAM : %s/%sMB
(%.2f%%)\n", $3,$2,$3*100/$2 }')
disk_info=$(df -h | awk '$NF=="/"{printf "Usage du disque : %d/%dGB (%s)\n",
$3,$2,$5}')


# Créer un fichier HTML avec les informations
html_file="/tmp/system_status.html"
echo "<html>
<head>
  <style>
    body { font-family: Arial, sans-serif; }
    h1 { color: #333333; text-align: center; }
    table { width: 50%; margin: auto; border-collapse: collapse; }
    th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd;
}
    th { background-color: #f2f2f2; }
  </style>
</head>
<body>
  <h1>État du Système</h1>
  <table>
    <tr><th>Composant</th><th>État</th></tr>
    <tr><td>CPU</td><td>$cpu_info</td></tr>
    <tr><td>RAM</td><td>$ram_info</td></tr>
    <tr><td>Disque</td><td>$disk_info</td></tr>
  </table>
</body>
</html>" > "$html_file"
# Envoyer l'e-mail
destinataire="blessedmetavers@gmail.com"
email_content="To: $destinataire\nFrom:
jepensedoncjecodex@gmail.com\nSubject: État du Système\nContent-Type:
text/html\n\n$(cat $html_file)"
