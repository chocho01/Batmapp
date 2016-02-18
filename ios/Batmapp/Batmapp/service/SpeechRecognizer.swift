import UIKit
import AVFoundation
import Material

/*
* Classe pour gérer la création d'alerte via une commande vocale
*/
class SpeechRecognizer: NSObject, SpeechKitDelegate, SKRecognizerDelegate {

    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    var label : MaterialLabel!
    var voiceSearch: SKRecognizer?

    /*
    * Initilisation de la libraire SpeechKit pour convertir du son en text
    */
    override init() {
        super.init()
        SpeechKit.setupWithID("NMDPTRIAL_martin_choraine_hotmail_fr20160128095300", host: "sandbox.nmdp.nuancemobility.net", port: 443, useSSL: false, delegate: self)
    }

    /*
    * Démarrer la reconnaisance vocale
    */
    func startRecording(label : MaterialLabel) {
        self.label = label
        self.voiceSearch = SKRecognizer(type: SKSearchRecognizerType, detection: UInt(SKLongEndOfSpeechDetection), language: "fra-FRA", delegate: self)
    }

    /*
    * Stoper la reconnaisance vocale
    */
    func stopRecorging() {
        if ((self.voiceSearch) != nil) {
            self.voiceSearch?.stopRecording()
        }
    }

    /*
    * Lorsque la reconnaisance vocale a commencé on affiche un message à l'utilisateur
    */
    func recognizerDidBeginRecording(recognizer: SKRecognizer!) {
        label.hidden = false
        label.text = "Recording..."
    }

    /*
    * Lorsque la reconnaisance vocale est termine on cache le message à l'utilisateur
    */
    func recognizerDidFinishRecording(recognizer: SKRecognizer!) {
        label.hidden = true
        label.text = ""
    }

    /*
    * Lorsque la reconnaisance vocale est terminé et a fonctionné
    * On envoie l'ensemble des potentiels résultats au serveur
    * Le serveur renvoi un message (OK ou pas OK) et le device lira le message
    */
    @objc func recognizer(recognizer: SKRecognizer!, didFinishWithResults results: SKRecognition!) {
        RestManager.createAlertFromSpeech(results.results as! [String]){
            result in
            if(result != nil){
                self.myUtterance = AVSpeechUtterance(string: result!)
                self.myUtterance.rate = 0.5
                self.myUtterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
                self.synth.speakUtterance(self.myUtterance)
            }
        }
    }

    /*
    * Lorsque la reconnaisance vocale est termine et n'a pas fonctionné
    * On averti l'utilisateur
    */
    @objc func recognizer(recognizer: SKRecognizer!, didFinishWithError error: NSError!, suggestion: String!) {
        label.hidden = false
        label.text = "An error occured..."
    }
}