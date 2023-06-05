//
//  FormRowStaticView.swift
//  TodoApp
//
//  Created by M_2195552 on 2023-06-05.
//

import SwiftUI

struct FormRowStaticView: View {
    //MARK: - Properties
    var icon: String
    var firstText: String
    var secondText: String
    
    //MARK: - Body
    var body: some View {
        HStack {
          ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
              .fill(Color.gray)
            Image(systemName: icon)
              .foregroundColor(.white)
          } //: ZStack
          .frame(width: 36, height: 36, alignment: .center)
          
          Text(firstText).foregroundColor(.gray)
          Spacer()
          Text(secondText)
        } //: HStack
    }
}

//MARK: - Preview
struct FormRowStaticView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
