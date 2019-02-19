//
//  PotCommunViewController.swift
//  Pot Commun
//
//  Created by Arnaud Pannatier on 14.09.16.
//  Copyright © 2016 Arnaud Pannatier. All rights reserved.
//

import UIKit
import CoreData


class PotCommunViewController: UIViewController {
     var tour = 50.0


    @IBOutlet weak var CompteurGreg: UILabel!
    var displayGreg :Int {
        get {
            return Int(CompteurGreg.text!)!
        }
        set {
            CompteurGreg.text = String(newValue)
        }
    }
    @IBAction func plusGreg(_ sender: UIButton) {
        addMouvement("Greg",cout: tour,date: Date())
        UpdateUI()
        
    }

    @IBAction func moinsGreg(_ sender: UIButton) {
        if(displayGreg > 0){
            removeMouvement("Greg")
            UpdateUI()
        }
        
    }
    
    
    @IBOutlet weak var CompteurAdrien: UILabel!
    var displayAdrien :Int {
        get {
            return Int(CompteurAdrien.text!)!
        }
        set {
            CompteurAdrien.text = String(newValue)
        }
    }

    @IBAction func plusAdrien(_ sender: UIButton) {
        addMouvement("Adrien",cout: tour,date: Date())
        UpdateUI()
    }
    @IBAction func moinsAdrien(_ sender: UIButton) {
        if(displayAdrien > 0){
            removeMouvement("Adrien")
            UpdateUI()
        }
    }
  
    @IBOutlet weak var CompteurDuc: UILabel!
    var displayDuc :Int {
        get {
            return Int(CompteurDuc.text!)!
        }
        set {
            CompteurDuc.text = String(newValue)
        }
    }
    @IBAction func plusDuc(_ sender: UIButton) {
        addMouvement("Duc",cout: tour,date: Date())
        UpdateUI()
    }
    @IBAction func moinsDuc(_ sender: UIButton) {
        if(displayDuc > 0){
            removeMouvement("Duc")
            UpdateUI()
        }
    }
    
    @IBOutlet weak var CompteurArnaud: UILabel!
    var displayArnaud :Int {
        get {
            return Int(CompteurArnaud.text!)!
        }
        set {
            CompteurArnaud.text = String(newValue)
        }
    }
    @IBAction func plusArnaud(_ sender: UIButton) {
        addMouvement("Arnaud", cout: tour, date: Date())
        UpdateUI()
    }
    @IBAction func moinsArnaud(_ sender: UIButton) {
        if(displayArnaud > 0){
            removeMouvement("Arnaud")
            UpdateUI()
        }
    }
    

    
    fileprivate func addMouvement(_ coloc: String, cout: Double, date :Date){
        managedObjectContext?.performAndWait {
            _ = Mouvement.MouvementWithmouvInfo(coloc, newCout: cout,newDate:  date, inManagedObjectContext: self.managedObjectContext!)
            do {
                try self.managedObjectContext?.save()
            }catch _ {
             print("Core Data Error")
            }
            
        }
        printDataBase()
        print("Done printing..")
    
    }
    fileprivate func removeMouvement(_ coloc: String){
        managedObjectContext?.performAndWait{
            Mouvement.removeLastMouvementofColoc(coloc, inManagedObjectContext: self.managedObjectContext!)
            do {
                try self.managedObjectContext?.save()
            }catch _ {
                print("Erreur de sauvegarde après suppression")
            }
        
        }
    
    }
    fileprivate func printDataBase (){
        managedObjectContext?.perform{
            if let results = try? self.managedObjectContext!.fetch(NSFetchRequest(entityName: "Mouvement")){
                print("\(results.count) Mouvements")
            }
            
        }
    
    
    }
    // MARK: Model
    
    var managedObjectContext : NSManagedObjectContext? =
        (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
    
    
    func UpdateUI() {
        
        print("Begin UPDATE")
        var countGreg = 0
        var totalGreg: Double = 0
        let nomGreg: String = "Greg"
        
        var countAdrien = 0
        var totalAdrien: Double = 0
        let nomAdrien: String = "Adrien"
        
        var countDuc = 0
        var totalDuc: Double = 0
        let nomDuc: String = "Duc"
        
        var countArnaud = 0
        var totalArnaud: Double = 0
        let nomArnaud: String = "Arnaud"
        
        managedObjectContext?.performAndWait{
            print("TOUR : \(self.tour)")
            
            let sommeExpression = NSExpression(format: "sum:(valeur)")
            let sommeED = NSExpressionDescription()
            sommeED.expression = sommeExpression
            sommeED.name = "sommeDesValeurs"
            sommeED.expressionResultType = .doubleAttributeType
            
            
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mouvement")
            request.predicate = NSPredicate(format: "coloc = %@", nomGreg)
            request.resultType = .dictionaryResultType
            request.propertiesToFetch = ["coloc", sommeED]
            request.propertiesToGroupBy = ["coloc"]
            do {
                
                let retour = try self.managedObjectContext?.fetch(request) as NSArray?
                if let retArray = retour {
                    if retArray.count > 0 {
                    totalGreg = ((retArray[0] as! NSDictionary)["sommeDesValeurs"]! as? Double)!
                    countGreg = Int(floor(totalGreg/self.tour))
                    }else {
                        totalGreg = 0
                        countGreg = 0
                    }
                }
                
            }catch _ {
                print("Erreur");
            }
   
            request.predicate = NSPredicate(format: "coloc = %@", nomAdrien)
            do {
                
                let retour = try self.managedObjectContext?.fetch(request) as NSArray?
                if let retArray = retour {
                    if retArray.count > 0 {
                    totalAdrien = ((retArray[0] as! NSDictionary)["sommeDesValeurs"]! as? Double)!
                    countAdrien = Int(floor(totalAdrien/self.tour))
                    }else {
                        totalAdrien = 0
                        countAdrien = 0
                    
                    }
                }
                
            }catch _ {
                print("Erreur");
            }
            
            request.predicate = NSPredicate(format: "coloc = %@", nomDuc)
            do {
                
                let retour = try self.managedObjectContext?.fetch(request) as NSArray?
                if let retArray = retour {
                    if retArray.count > 0 {
                    totalDuc = ((retArray[0] as! NSDictionary)["sommeDesValeurs"]! as? Double)!
                    countDuc = Int(floor(totalDuc/self.tour))
                    }else{
                        totalDuc = 0
                        countDuc = 0
                    }
                }
                
            }catch _ {
                print("Erreur");
            }
            
            request.predicate = NSPredicate(format: "coloc = %@", nomArnaud)
            do {
                
                let retour = try self.managedObjectContext?.fetch(request) as NSArray?
                if let retArray = retour {
                    if retArray.count > 0 {
                    totalArnaud = ((retArray[0] as! NSDictionary)["sommeDesValeurs"]! as? Double)!
                    countArnaud = Int(floor(totalArnaud/self.tour))
                    }else {
                        totalArnaud = 0
                        countArnaud = 0
                    }
                }
                
            }catch _ {
                print("Erreur");
            }
            
            
            
            /*
            request = NSFetchRequest(entityName: "Mouvement")
            request.predicate = NSPredicate(format: "coloc = %@ AND valeur = %@", nomAdrien, NSNumber(double: self.tour))
            countAdrien = self.managedObjectContext!.countForFetchRequest(request , error: nil)
            
            request.predicate = NSPredicate(format: "coloc = %@ AND valeur = %@", nomDuc, NSNumber(double: self.tour))
            countDuc = self.managedObjectContext!.countForFetchRequest(request , error: nil)
            
            request.predicate = NSPredicate(format: "coloc = %@ AND valeur = %@", nomArnaud, NSNumber(double: self.tour))
            countArnaud = self.managedObjectContext!.countForFetchRequest(request , error: nil)*/
        }
        print("END UPDATE - GRIS")
        displayGreg = countGreg
        tempoGreg = totalGreg
        tempoLabeldeGreg.textColor = UIColor(white: 0.5, alpha: 1)
        displayAdrien = countAdrien
        tempoAdrien = totalAdrien
        tempoLabeldeAdrien.textColor = UIColor(white: 0.5, alpha: 1)
        displayDuc = countDuc
        tempoDuc = totalDuc
        tempoLabeldeDuc.textColor = UIColor(white: 0.5, alpha: 1)
        displayArnaud = countArnaud
        tempoArnaud = totalArnaud
        tempoLabeldeArnaud.textColor = UIColor(white: 0.5, alpha: 1)
        
    
    }
    
    
    //INITIALISATION
    override func viewDidLoad() {
        UpdateUI()
        

    }
// SWIPE -------------------------------------------------------------------------------
    func prixFromTranslate(_ point: CGPoint) -> Double {
        var retour: Double
        retour = floor((Double(point.x)*Double(point.x) + Double(point.y)*Double(point.y))*2/200)/2
        return retour
    }
    
    ///LABEL
    
    
    
    @IBOutlet weak var tempoLabeldeGreg: UILabel!
    var tempoGreg: Double {
        get {
            return Double(tempoLabeldeGreg.text!)!
        }
        set {
            tempoLabeldeGreg.text = String(newValue)
        }
    }
    @IBOutlet weak var tempoLabeldeAdrien: UILabel!
    var tempoAdrien: Double {
        get {
            return Double(tempoLabeldeAdrien.text!)!
        }
        set {
            tempoLabeldeAdrien.text = String(newValue)
        }
    }
    @IBOutlet weak var tempoLabeldeDuc: UILabel!
    var tempoDuc: Double {
        get {
            return Double(tempoLabeldeDuc.text!)!
        }
        set {
            tempoLabeldeDuc.text = String(newValue)
        }
    }
    @IBOutlet weak var tempoLabeldeArnaud: UILabel!
    var tempoArnaud: Double {
        get {
            return Double(tempoLabeldeArnaud.text!)!
        }
        set {
            tempoLabeldeArnaud.text = String(newValue)
        }
    }


    
    
    //SUBMIT
    
    @IBAction func submitPanGreg(_ sender: UIButton) {
        addMouvement("Greg",cout: tempoGreg,date: Date())
        UpdateUI()
    }
    @IBAction func submitPanAdrien(_ sender: UIButton) {
        addMouvement("Adrien",cout: tempoAdrien,date: Date())
        UpdateUI()
    }
  
    @IBAction func submitPanDuc(_ sender: UIButton) {
        addMouvement("Duc",cout: tempoDuc,date: Date())
        UpdateUI()
    }
    
    @IBAction func submitPanArnaud(_ sender: UIButton) {
        addMouvement("Arnaud",cout: tempoArnaud,date: Date())
        UpdateUI()
    }
    
    /// MARK : Swipe Function
    //GREG
    
    internal func panPlusGreg(_ gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .began :
                tempoGreg = 0.0
                tempoLabeldeGreg.textColor = UIColor(white: 0,alpha: 1)
                break;
        case .changed:
            let translation = gesture.translation(in: plusSwipe)
            tempoGreg += prixFromTranslate(translation)
            gesture.setTranslation(CGPoint.zero, in: plusSwipe)
        
        default:
        break;
        }
    }
    internal func panMoinsGreg(_ gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .began :
            tempoGreg = 0.0
            tempoLabeldeGreg.textColor = UIColor(white: 0,alpha: 1)
            break;
        case .changed:
            let translation = gesture.translation(in: plusSwipe)
            tempoGreg -= prixFromTranslate(translation)
            gesture.setTranslation(CGPoint.zero, in: plusSwipe)
            
        default:
            break;
        }
    }
    
    internal func panPlusAdrien(_ gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .began :
            tempoAdrien = 0.0
            tempoLabeldeAdrien.textColor = UIColor(white: 0,alpha: 1)
            break;
        case .changed:
            let translation = gesture.translation(in: plusSwipe)
            tempoAdrien += prixFromTranslate(translation)
            gesture.setTranslation(CGPoint.zero, in: plusSwipe)
            
        default:
            break;
        }
    }
    internal func panMoinsAdrien(_ gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .began :
            tempoAdrien = 0.0
            tempoLabeldeAdrien.textColor = UIColor(white: 0,alpha: 1)
            break;
        case .changed:
            let translation = gesture.translation(in: plusSwipe)
            tempoAdrien -= prixFromTranslate(translation)
            gesture.setTranslation(CGPoint.zero, in: plusSwipe)
            
        default:
            break;
        }
    }
    
    internal func panPlusDuc(_ gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .began :
            tempoDuc = 0.0
            tempoLabeldeDuc.textColor = UIColor(white: 0,alpha: 1)
            break;
        case .changed:
            let translation = gesture.translation(in: plusSwipe)
            tempoDuc += prixFromTranslate(translation)
            gesture.setTranslation(CGPoint.zero, in: plusSwipe)
            
        default:
            break;
        }
    }
    internal func panMoinsDuc(_ gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .began :
            tempoDuc = 0.0
            tempoLabeldeDuc.textColor = UIColor(white: 0,alpha: 1)
            break;
        case .changed:
            let translation = gesture.translation(in: plusSwipe)
            tempoDuc -= prixFromTranslate(translation)
            gesture.setTranslation(CGPoint.zero, in: plusSwipe)
            
        default:
            break;
        }
    }
    
    internal func panPlusArnaud(_ gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .began :
            tempoArnaud = 0.0
            tempoLabeldeArnaud.textColor = UIColor(white: 0,alpha: 1)
            break;
        case .changed:
            let translation = gesture.translation(in: plusSwipe)
            tempoArnaud += prixFromTranslate(translation)
            gesture.setTranslation(CGPoint.zero, in: plusSwipe)
            
        default:
            break;
        }
    }
    internal func panMoinsArnaud(_ gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .began :
            tempoArnaud = 0.0
            tempoLabeldeArnaud.textColor = UIColor(white: 0,alpha: 1)
            break;
        case .changed:
            let translation = gesture.translation(in: plusSwipe)
            tempoArnaud -= prixFromTranslate(translation)
            gesture.setTranslation(CGPoint.zero, in: plusSwipe)
            
        default:
            break;
        }
    }
    
    
    
    //SWIIIIIIIIIIIIIIIIIIIIPE BUTTTON
    
    @IBOutlet weak var plusSwipe: UIButton! {
        didSet {
            let recognizer = UIPanGestureRecognizer(
                target : self, action: #selector(PotCommunViewController.panPlusGreg(_:))
            )
            plusSwipe.addGestureRecognizer(recognizer)
        }
    }
    @IBOutlet weak var moinsSwipeGreg: UIButton! {
        didSet {
            let recognizer = UIPanGestureRecognizer(
                target: self, action: #selector(PotCommunViewController.panMoinsGreg(_:))
            )
            moinsSwipeGreg.addGestureRecognizer(recognizer)
        
        }
    }
    
    @IBOutlet weak var plusSwipeAdrien: UIButton! {
        didSet {
            let recognizer = UIPanGestureRecognizer(
                target : self, action: #selector(PotCommunViewController.panPlusAdrien(_:))
            )
            plusSwipeAdrien.addGestureRecognizer(recognizer)
        }
    }
    @IBOutlet weak var moinsSwipeAdrien: UIButton! {
        didSet {
            let recognizer = UIPanGestureRecognizer(
                target : self, action: #selector(PotCommunViewController.panMoinsAdrien(_:))
            )
            moinsSwipeAdrien.addGestureRecognizer(recognizer)
        }
    }
    @IBOutlet weak var plusSwipeDuc: UIButton! {
        didSet {
            let recognizer = UIPanGestureRecognizer(
                target : self, action: #selector(PotCommunViewController.panPlusDuc(_:))
            )
            plusSwipeDuc.addGestureRecognizer(recognizer)
        }
    }
    @IBOutlet weak var moinsSwipeDuc: UIButton! {
        didSet {
            let recognizer = UIPanGestureRecognizer(
                target : self, action: #selector(PotCommunViewController.panMoinsDuc(_:))
            )
            moinsSwipeDuc.addGestureRecognizer(recognizer)
        }
    }

    @IBOutlet weak var plusSwipeArnaud: UIButton! {
        didSet {
            let recognizer = UIPanGestureRecognizer(
                target : self, action: #selector(PotCommunViewController.panPlusArnaud(_:))
            )
            plusSwipeArnaud.addGestureRecognizer(recognizer)
        }
    }
    @IBOutlet weak var moinsSwipeArnaud: UIButton! {
        didSet {
            let recognizer = UIPanGestureRecognizer(
                target : self, action: #selector(PotCommunViewController.panMoinsArnaud(_:))
            )
            moinsSwipeArnaud.addGestureRecognizer(recognizer)
        }
    }

    




    
    
    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
