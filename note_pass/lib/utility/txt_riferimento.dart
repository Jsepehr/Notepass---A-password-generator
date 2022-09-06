import 'package:flutter/material.dart';

class Txtriferimenti {
  static const String _fixedString =
      "00123,00213,00231,00312,00321,01023,01032,02031,02310,03021,03120,03210"
      ",10023,10032,10203,10302,10320,12003,13002,13200,20031,20130,20301,21003,23100,30012,30102"
      ",31002,31020,31200,32010,32100,01123,01132,01231,02113,10123,10132,10312,11023,11032,11230"
      ",12013,12130,12301,12310,13012,13102,13120,13201,13210,20113,20131,21031,21103,21130,21301"
      ",21310,23110,30211,31012,31210,32011,32110,01223,01232,02132,02213,02231,02312,10322,12023"
      ",12230,12320,13022,13202,13220,20132,20231,20321,21023,21302,21320,22013,22031,22130,22310"
      ",23021,23201,30122,30212,30221,31022,31220,32021,32201,01233,01323,02133,02331,03123,03132"
      ",03321,10233,10332,13203,13320,21033,23013,23103,23130,23301,23310,30213,30231,30312,30321"
      ",31032,31203,31302,32013,32031,32103,33012,33021,33102,33201,33210";

  static final _descrizione = RichText(
    text: const TextSpan(
      style: TextStyle(fontSize: 16, color: Colors.black, height: 1.3),
      text:
          "Once the configuration is done, the passwords will be saved on your device: it is advisable to change them before the first use.",
    ),
  );
  static final _descrizioneIta = RichText(
    text: const TextSpan(
      style: TextStyle(fontSize: 16, color: Colors.black, height: 1.3),
      text:
          "Una volta fatta la configurazione, le password verranno salvate sul tuo dispositivo: si consiglia di modificarle prima del primo utilizzo.",
    ),
  );

  static const _avvisoGenPass =
      'This action will generate a new list of passwords. The saved passwords, if any, will be eliminated.';
  static const _avvisoGenPassIta =
      'Questa azione genererà un nuovo elenco di password. Le password salvate, se presenti, verranno eliminate.';

  static const Text _descrizioneConfig = Text(
    "1. Choose an image \n2. Type keywords \n3. Push the \"Generate\" button \nChoose an unique image and do not share it with anybody",
    style: TextStyle(height: 1.5),
  );
  static const Text _descrizioneConfigIta = Text(
    "1. Scegli un'immagine \n2. Digita le parole chiave \n3. Premi \"Crea\" \nScegli un'immagine unica e non condividerla con nessuno",
    style: TextStyle(height: 1.5),
  );

  static const String _config = "Configurations";
  static const String _configIta = "Configurazioni";

  static const String _testatahome = "Notepass - Home";
  static const String _testataConfig = "Notepass - Configurations";
  static const String _testataPasswords = "Notepass - Passwords";
  static const String _testataAbout = "Notepass - About";

  static const String _keyword = "Keywords";
  static const String _keywordIta = "Parole chiavi";
  static const String _pwds = "Passwords";

  static const String _chooseImage = "Choose an image";
  static const String _chooseImageIta = "Scegli immagine";

  static const String _done = "Generate";
  static const String _doneIta = "Crea";

  static const String _edit = "Edit";
  static const String _editIta = "Modifica";

  static const String _cancel = "Cancel";
  static const String _annulla = "Annulla";

  static const String _save = "Save Changes";
  static const String _salva = "Salva le modifiche";

  static const String _gen = "Generating Passwords";
  static const String _genIta = "Creazione Password";

  static const String _approvEng = "Approve";
  static const String _approvIta = "Approva";

  static const String _hint = "Hint";
  static const String _hintIta = "Suggerimento";

  static const String _copy = "Share";
  static const String _copia = "Condividi";

  static const String _genrated = "Passwords are generated";
  static const String _generatedIta = "Le password sono state create";

  static const String _chSavedEng = "Chenges are saved successfully";
  static const String _chSavedIta =
      "Le modifiche sono state salvate correttamente";

  static const String _copyToMem = "Copied to memory";
  static const String _copiaToMemIta = "Copiato in memoria";

  static const String _pkiaviEng = "Keywords";
  static const String _pkiaviIta = "Parole chiavi";

  static const String _pchiaveHintEng = "Keywords here ...";
  static const String _pchiaveHintIta = "Parole chiavi qui ...";

  static const String _aboutEng = """Hi, I am Sepehr, creator of Notepass. 
Remembering and managing passwords has always been a problem for me, 
so I had the idea of using images as useful elements to generate strong and secure passwords. Images are much easier to remember than a complicated set of letters and numbers. 
\nIn Notepass app, passwords are created based on image and the keyword entered by the user in configurations section.
Therefore the user can always regenerate the same password list by inserting the same image and the same keywords used previously.
""";
  static const String _aboutIta = """Ciao, sono Sepehr, creatore di Notepass. 
Ricordare e gestire le password è sempre stato un problema per me, così ho avuto l'idea di sfruttare le immagini come elementi utili per generare password efficaci e sicure. Infatti le immagini sono molto più facili da ricordare rispetto ad un insieme complicato di lettere e numeri.
\nNotepass genera una serie di password complesse e uniche. Le password vengono create in base all'immagine e alla parola chiave inserite dall'utente nella sezione "configurazioni".
Quindi l'utente può rigenerare sempre lo stesso elenco di password inserendo la stessa immagine e le stesse parole chiavi usate precedentemente.""";

  getTxtAbout(lang) {
    switch (lang) {
      case "eng":
        return _aboutEng;
      case "ita":
        return _aboutIta;
    }
  }

  getTxtInputTestata(lang) {
    switch (lang) {
      case "eng":
        return _pkiaviEng;
      case "ita":
        return _pkiaviIta;
    }
  }

  getTxtInputHint(lang) {
    switch (lang) {
      case "eng":
        return _pchiaveHintEng;
      case "ita":
        return _pchiaveHintIta;
    }
  }

  getTxtToastCopied(lang) {
    switch (lang) {
      case "eng":
        return _copyToMem;
      case "ita":
        return _copiaToMemIta;
    }
  }

  getTxtToastSalvate(lang) {
    switch (lang) {
      case "eng":
        return _chSavedEng;
      case "ita":
        return _chSavedIta;
    }
  }

  getTxtToastGenerate(lang) {
    switch (lang) {
      case "eng":
        return _genrated;
      case "ita":
        return _generatedIta;
    }
  }

  getTxtCopy(lang) {
    switch (lang) {
      case "eng":
        return _copy;
      case "ita":
        return _copia;
    }
  }

  getTxtHint(lang) {
    switch (lang) {
      case "eng":
        return _hint;
      case "ita":
        return _hintIta;
    }
  }

  getTxtApprova(lang) {
    switch (lang) {
      case "eng":
        return _approvEng;
      case "ita":
        return _approvIta;
    }
  }

  getTxtGen(lang) {
    switch (lang) {
      case "eng":
        return _gen;
      case "ita":
        return _genIta;
    }
  }

  getTxtSalva(lang) {
    switch (lang) {
      case "eng":
        return _save;
      case "ita":
        return _salva;
    }
  }

  getTxtAnnulla(lang) {
    switch (lang) {
      case "eng":
        return _cancel;
      case "ita":
        return _annulla;
    }
  }

  getTxtAvvisoGen(lang) {
    switch (lang) {
      case "eng":
        return _avvisoGenPass;
      case "ita":
        return _avvisoGenPassIta;
    }
  }

  getTxtConfiguration(lang) {
    switch (lang) {
      case "eng":
        return _config;
      case "ita":
        return _configIta;
    }
  }

  getTxtDone(lang) {
    switch (lang) {
      case "eng":
        return _done;
      case "ita":
        return _doneIta;
    }
  }

  getTxtFixedString() {
    return _fixedString;
  }

  getTxtTestata(qualeTestata) {
    switch (qualeTestata) {
      case "home":
        return _testatahome;
      case "config":
        return _testataConfig;
      case "pass":
        return _testataPasswords;
      case "about":
        return _testataAbout;
    }
  }

  getTxtDesLangHome(lang) {
    switch (lang) {
      case "ita":
        return _descrizioneIta;

      case "eng":
        return _descrizione;
    }
  }

  getTxtDesLangConfig(lang) {
    switch (lang) {
      case "ita":
        return _descrizioneConfigIta;

      case "eng":
        return _descrizioneConfig;
    }
  }

  getTxtKeywords(lang) {
    switch (lang) {
      case "eng":
        return _keyword;
      case "ita":
        return _keywordIta;
    }
  }

  getTxtEdit(lang) {
    switch (lang) {
      case "eng":
        return _edit;
      case "ita":
        return _editIta;
    }
  }

  getTxtPwd() {
    return _pwds;
  }

  getTxtImmage(lang) {
    switch (lang) {
      case "eng":
        return _chooseImage;
      case "ita":
        return _chooseImageIta;
    }
  }
}
