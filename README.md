# LightSensor
Read Ambient light sensor value from iPhone/iPad

# Sensors

Lis les valeurs depuis les capteurs de température, de tension et de courant des iPad/iPhone.

Cet outil utilise une librairie privée qui n'est pas officielle sur iPhone/iPad : IOKit.

```
iPad:~ root# lightsensor test
Usage: lightsensor
iPad:~ root# lightsensor 

IOKit Ambient Light Sensor Info >>


=> Actual values: 
-------------------------
AmbientLight = 0.3921;
AmbientLightPourcent = 39.21;
MaxAmbientLight = 5000;
RAW = 205;
DayLight = 0;

```

# Comment interpréter les valeurs ?

- AmbientLight => `ratio à 1 de la valeur (maximum 1)`
- AmbientLightPourcent => `ratio à 100 de la valeur brut (pourcentage/maximum 100)`
- MaxAmbientLight => `valeur fixe indicative du maximum)`
- RAW => `affiche la valeur brute (maximum 5000)`
- DayLight => `affiche 1 quand la valeur plafond est atteinte (lumière directe/Soleil...)`
