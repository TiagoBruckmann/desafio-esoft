# desafio_esoft

Projeto para desafio da empresa Esoft Sistemas

Pacotes utilizados

<ul>
    <li>font_awesome_flutter</li>
    <li>firebase_crashlytics</li>
    <li>fake_cloud_firestore</li>
    <li>firebase_analytics</li>
    <li>cloud_firestore</li>
    <li>cupertino_icons</li>
    <li>firebase_core</li>
    <li>find_dropdown</li>
    <li>flutter_bloc</li>
    <li>test</li>
</ul>

### :star: Gerar APK release da loja android

```sh
flutter build appbundle
```

### :star2: Gerar APK release com ofuscação de codigo
##### Deixa mais leve o app pois gera para cada versão de dispositivo

```sh
flutter build apk --split-per-abi
```