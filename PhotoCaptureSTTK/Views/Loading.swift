//
//  Loading.swift
//  PhotoCaptureSTTK
//
//  Created by Victor David Ponce Quintanilla on 23/02/24.
//

import SwiftUI

struct Loading: View {
    var body: some View {
        VStack(spacing:20){
            ProgressView()
            Text("Mandando a la base de datos")
        }
        
    }
}

#Preview {
    Loading()
}
