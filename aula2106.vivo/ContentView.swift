//
//  ContentView.swift
//  aula2106.vivo
//
//  Created by F F on 21/06/2024.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State var enlarge = false
	
	var dragGesture: some Gesture {
		DragGesture()
			.targetedToAnyEntity()
			.onChanged { value in
				print("DRAGGING!!", value.entity.name)
				value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
				
			}
	}

    var body: some View {
        VStack {
            RealityView { content in
                // Add the initial RealityKit content
                if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                    content.add(scene)
					scene.components.set(InputTargetComponent())
					scene.generateCollisionShapes(recursive: true)
                }
            } update: { content in
                // Update the RealityKit content when SwiftUI state changes
                if let scene = content.entities.first {
                    let uniformScale: Float = enlarge ? 1.4 : 1.0
                    scene.transform.scale = [uniformScale, uniformScale, uniformScale]
					print("Changing size of asset to ", uniformScale)
                }
            }
			.gesture(TapGesture().targetedToAnyEntity().onEnded { _ in
                enlarge.toggle()
				print("Tap ended")
            })
			.gesture(dragGesture)
		


            VStack {
                Toggle("Enlarge RealityView Content", isOn: $enlarge)
                    .toggleStyle(.button)
            }.padding().glassBackgroundEffect()
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
