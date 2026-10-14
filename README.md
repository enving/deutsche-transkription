# Deutsche Transkription

**Diktieren auf Deutsch — Hotkey drücken, sprechen, loslassen. Der Text steht in der App, in der der Cursor blinkt.**

Egal ob E-Mail, Editor, Terminal, Browser oder Chat: Deutsche Transkription tippt das Gesprochene systemweit in jedes Programm. Auf Wunsch **komplett offline** mit einem deutsch-optimierten Spracherkennungs-Modell — ohne Cloud, ohne Konto, ohne Abo. Läuft auf **macOS, Linux und Windows**.

## Warum besser als Apple- oder Windows-Diktat?

|  | Deutsche Transkription | Apple Diktierfunktion | Windows-Spracherkennung |
|---|---|---|---|
| Plattformen | macOS, Linux, Windows | nur Apple-Geräte | nur Windows |
| Quelloffen (MIT) | Ja | Nein | Nein |
| Hersteller-Bindung | Keine | Apple-Gerät erforderlich | Windows erforderlich |
| Komplett offline nutzbar | Ja, eingebaut (ein Klick) | Nur teilweise | Nur teilweise |
| Deutsch-Spezialmodell | Ja (Parakeet-DE-Feinabstimmung) | Systemstandard | Systemstandard |
| Anbieter frei wählbar (Cloud, eigener Server, offline) | Ja (Groq, OpenAI, Yorik, lokal) | Nein | Nein |
| Eigener Server im Heimnetz | Ja (Yorik) | Nein | Nein |
| Hotkey frei belegbar | Ja (F-Tasten, Modifier, Maus, Doppel-Tap) | Eingeschränkt | Eingeschränkt |
| Konto erforderlich | Nein | Nein, aber Apple-Gerät | Nein, aber Windows |

Kurz: Die System-Diktate gehören zum Gerät — Deutsche Transkription gehört **dir**. Gleiche Bequemlichkeit (eine Taste, Text landet in jeder App), aber ohne Hersteller-Bindung, mit echtem Offline-Modus und einem Modell, das auf Deutsch trainiert ist.

## Funktionen

- Push-to-talk (halten) oder Toggle (antippen zum Starten/Stoppen)
- Tray-Icon mit Status (bereit / Aufnahme / Transkription)
- Vier Transkriptions-Wege:
  - **Lokal (Parakeet DE, CPU, offline)** — deutsche Feinabstimmung von `nvidia/parakeet-tdt-0.6b-v3` (int8 ONNX via [sherpa-onnx](https://github.com/k2-fsa/sherpa-onnx)). ~50 ms Dekodierung für 2 s Sprache bei 4 Threads. Kein Netz, kein Schlüssel.
  - **Yorik (Heimserver)** — ein Parakeet für alle Geräte im Haus; dieser Rechner braucht kein Modell.
  - **Groq**-Cloud (`whisper-large-v3-turbo`, `whisper-large-v3`)
  - **OpenAI**-Cloud (`gpt-4o-mini-transcribe`, `gpt-4o-transcribe`, `whisper-1`)
- Hotkey frei wählbar: F1–F12, Modifier (Strg/Alt/Shift), Maus-Seitentasten — auf macOS zusätzlich **Command-Doppeltipp**
- Mindest-Haltedauer gegen versehentliche Auslöser
- Schlüssel liegen lokal in `~/.config/dictate/config.json` (Modus 600)

## Schnellstart (macOS)

```bash
git clone https://github.com/enving/deutsche-transkription.git
cd deutsche-transkription
python3 -m venv .venv
./.venv/bin/pip install PyQt6 sounddevice pynput requests numpy sherpa-onnx soundfile huggingface_hub
```

Danach **Dictate starten.command** doppelklicken (nutzt die projekt-lokale `.venv`). Für Offline-Deutsch **Parakeet-Modell-laden.command** doppelklicken: lädt das Modell (~640 MB, fortsetzbar, prüfsummen-verifiziert) und stellt alles um. Dictate einmal neu starten — fertig.

Beim ersten Start fragt macOS nach der Berechtigung, in andere Fenster zu tippen (Bedienungshilfen) — erlauben, sonst kommt transkribierter Text nie im Zielfenster an. Die Prüfung läuft bei jedem Start und heilt sich z. B. nach einem Python-Update selbst.

## Schnellstart (Linux)

```bash
git clone https://github.com/enving/deutsche-transkription.git
cd deutsche-transkription
./install.sh
```

Richtet Systempakete, Python-Pakete, `input`-Gruppe (für Wayland) und einen Menüeintrag ein. Nach Gruppenänderung einmal ab-/anmelden. Details und Fallstricke: `WAYLAND_NOTES.md`.

## Schnellstart (Windows)

```bash
pip install PyQt6 sounddevice pynput requests numpy
python gui.py
```

Hotkeys und Tippen laufen über `pynput`. Mit dem Yorik-Anbieter braucht der Rechner kein Modell.

## Einstellungen

Standard-Hotkey ist **F9**: halten, sprechen, loslassen. In den **Settings** lassen sich Anbieter, Modus (Push-to-talk/Toggle), Hotkey, Modell, CPU-Threads (lokal) und Mindest-Haltedauer ändern.

## Datenschutz

- Der lokale Anbieter schickt **nichts** ins Netz — Erkennung läuft auf der eigenen CPU.
- Fehlgeschlagene Aufnahmen mit hörbarem Ton landen als WAV unter `~/.local/state/dictate/failed/` (nur die neuesten 3, nichts wird hochgeladen, Ordner jederzeit löschbar).
- Das Protokoll (`~/.local/state/dictate/dictate.log`) enthält nur Längen, Pegel und Zeiten — **nie** den transkribierten Text.
- Cloud-Anbieter übertragen nur den jeweiligen Audio-Schnipsel an den gewählten Dienst.

## Herkunft und Dank

Deutsche Transkription baut auf [Dictate](https://github.com/winidi/dictate) (MIT) auf, erweitert um macOS-Ausbau (Quartz-Hotkey, Bedienungshilfen-Dialog, Starter-Skripte). Modell: [parakeet-primeline](https://huggingface.co/flozen1981/parakeet-primeline-onnx) (CC-BY-4.0, Feinabstimmung), [NVIDIA](https://huggingface.co/nvidia/parakeet-tdt-0.6b-v3) (Basismodell), [k2-fsa/sherpa-onnx](https://github.com/k2-fsa/sherpa-onnx) (Laufzeitumgebung).

Lizenz: MIT (siehe `LICENSE`).
