//
//  ViewController.swift
//  ARCleon
//
//  Created by Mark on 7/7/25.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in:sceneView)
            let results = sceneView.hitTest(touchLocation, types: .featurePoint)
            if let result = results.first{
                addDot(at:result)
            }
        }
        func addDot(at results :ARHitTestResult){
            let dotGeometry = SCNSphere(radius: 0.005)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.red
            
            dotGeometry.materials = [material]
            
            let dotNode = SCNNode(geometry: dotGeometry)
            
            dotNode.position = SCNVector3(x: results.worldTransform.columns.3.x, y: results.worldTransform.columns.3.y, z: results.worldTransform.columns.3.z)
            
            sceneView.scene.rootNode.addChildNode(dotNode)

            dotNodes.append(dotNode)
            
            if dotNodes.count >= 2{
                calculate()
            }
        }
        
        func calculate(){
            
            let start = dotNodes[0]
            let end = dotNodes[1]
            
            var startY = start.position.y
            var startX = start.position.x
            var startZ = start.position.z
            
            var endY = end.position.y
            var endZ = end.position.z
            var endX = end.position.x
            
            var toadAlly = sqrt(pow(endX - startX,2) + pow(endY - startY,2) + pow(endX - startX,2))
            
            updateText(text: "\(abs(toadAlly))", atPosition: end.position)
            
            
        }
        
        func updateText(text: String, atPosition: SCNVector3){
            
            let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
            
            textGeometry.firstMaterial?.diffuse.contents = UIColor.red
            
            let textNode = SCNNode(geometry: textGeometry)
            
            textNode.position = SCNVector3(atPosition.x, atPosition.y + 0.01, atPosition.z)
            
            textNode.scale = SCNVector3(0.01,0.01,0.01)
            
            sceneView.scene.rootNode.addChildNode(textNode)
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
}
