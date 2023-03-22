//
//  EventPicture.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/20/23.
//
 
import SwiftUI

struct EventPicture: View {
    @Binding var uploadedImage : UIImage
    @Binding var initialImage : UIImage
    @State private var uploadPictureSheet : Bool = false
    @State private var showPermissionDenied : Bool = false
    @State private var showImagePicker : Bool = false
    @State private var selectedContentType: UIImagePickerController.SourceType =
        .photoLibrary
    var body: some View {
        VStack{
            Button {
                uploadPictureSheet.toggle()
            } label: {
                if uploadedImage == initialImage {
                    Image(systemName: "photo")
                        .resizable()
//                        .centerCropped()
//                        .frame(width: geo.size.width * 0.3, height: geo.size.width * 0.3)
                    
                        .aspectRatio(contentMode: .fit)
//                        .clipShape(Circle())
//                        .overlay(
//                            Circle().stroke(.gray,lineWidth:2)
//                        )
                        .padding(.bottom,20)
                }else{
                    Image(uiImage: uploadedImage)
                        .resizable()
                        .centerCropped()
//                        .frame(width: geo.size.width * 0.3, height: geo.size.width * 0.3)
                        .aspectRatio(contentMode: .fill)
//                        .clipShape(Circle())
//                        .overlay(
//                            Circle().stroke(.black,lineWidth:2)
//                        )
                        .padding(.bottom,20)
                }
             
            }
            .padding(.bottom,5)
        }
        .sheet(isPresented: $uploadPictureSheet){
            ContentTypeView(onContentTypeSelected: { contentType in
                switch contentType{
                case .permissionDenied:
                    showPermissionDenied.toggle()
                    return
                case .contentType(let sourceType):
                    self.selectedContentType = sourceType
                    showImagePicker.toggle()
                    return
                }
            })
        }
        .sheet(isPresented: $showImagePicker){
            ImagePicker(sourceType: selectedContentType, selectedImage: $uploadedImage)
        }
    }
}

//struct EventPicture_Previews: PreviewProvider {
//    static var previews: some View {
//        EventPicture()
//    }
//}
