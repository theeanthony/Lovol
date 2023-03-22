//
//  ConfirmImages.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 3/17/23.
//

import SwiftUI

struct ConfirmImages: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var eventViewModel : EventViewModel

    var videos : URL
    var images: [UIImage]
    var event : EventModel
    @State private var thumbnails : [UIImage] = []
    @State private var caption: String = ""
    @State private var isGlobal: Bool = false
    @State private var charLimit: Int = 200
    @State private var showImagesSheet : Bool = false
    @State private var index : Int = 0
    @State private var pictureSubmitted : Bool = false
    
    @State private var uploadError : Bool = false
    @State private var loadingPics : Bool = false
    @Binding var reviewSheet : Bool
    @Binding var totalPointsEarned : Int
    @Binding var isCelebrationPresent : Bool
    @Binding var confirmedSubmission : Bool
    @State private var progress : Float = 0
    @State private var loadingThumbnails : Bool = true
    var body: some View {
        GeometryReader{geo in
            VStack {
                Spacer()
                
                ScrollView {
                    HStack(alignment: .top) {
                       
                        if loadingThumbnails{
                            ProgressView()
                        }else{
                            Button {
                                self.showImagesSheet = true
                            } label: {
                                Image(uiImage: thumbnails[0])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geo.size.width * 0.2, height: geo.size.width * 0.2)
                                    .clipped()
                                    .padding()
                            }
                        }
              

                
                        
                        TextField("", text: $caption, axis: .vertical)
                            .padding()
                            .lineLimit(3)
                    
                            .placeholder(when: caption.isEmpty) {
                                Text("Write a caption.")
                                    .opacity(0.5)
                                    .font(.custom("Rubik Regular", size: 14))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .onChange(of: caption, perform: { newValue in
                                if (newValue.count >= charLimit) {
                                    caption = String(newValue.prefix(charLimit))
                                }
                            })
                    }
                    ExDivider(color:.white)
                    HStack{
                        Toggle("Global Feed", isOn: $isGlobal)
                            .toggleStyle(SwitchToggleStyle())
                            .tint(AppColor.lovolPinkish)
                            .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                    }
                    .padding(.horizontal,15)
                    
                }
                .frame(height:geo.size.height * 0.8)
                .onTapGesture { // add gesture to dismiss keyboard when clicked outside the keyboard view
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                HStack{
                    Button {
                                        submitPhoto()

                    } label: {
                        Text("Submit")
                            .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))

                    }
                }
            


            }
            .background(BackgroundView())
            .overlay(VStack{
                HStack{
                    Button {
                       dismiss()
                    } label: {
                        Image(systemName:"chevron.left").foregroundColor(.white)
                    }

                    Spacer()
                    Text("Confirm Post")
                        .font(.custom("Rubik Bold", size: 14))
                        .foregroundColor(.white)
                    Spacer()
                }
                Spacer()
            }.padding()

            )

            .sheet(isPresented: $showImagesSheet) {
                ImagePopupView(images: images, selectedImageIndex: $index)
                
            }
            .showLoading(loadingPics,progress: $progress)

            
        }
        .onAppear(perform:onAppear)
    }
    private func onAppear(){
        self.thumbnails = images
        if let thumbnail = generateThumbnail(for: videos) {
            thumbnails.append(thumbnail)
            loadingThumbnails = false 
        } else {
            // Display placeholder image
       
        }
    }
    private func submitPhoto(){
        
        pictureSubmitted = true
        if thumbnails.isEmpty  {
            return
        }
        
        self.loadingPics = true
        eventViewModel.submitEvent(caption:caption,useMultiplier:false,isGlobal:isGlobal,event: event, photo: images,videos:videos,progress:{
            progress in
            DispatchQueue.main.async {
                self.progress = progress
                print("Progress update \(progress)")
            }
            
        }, onCompletion:{ result in
            switch result {
                
            case .success(let numberOfPoints):
                self.loadingPics = false
                
                pictureSubmitted = false
                self.totalPointsEarned = numberOfPoints
                print("points in this \(numberOfPoints)")
                reviewSheet = true
                self.isCelebrationPresent = true
                self.loadingPics = false
                self.confirmedSubmission = true
                dismiss()
                
                
            case .failure(let error):
                
                if error == .downloadError{
                    pictureSubmitted = false
                    print("error submitting photo for event \(error)")
                    self.loadingPics = false
                    
                    uploadError = true
                    return
                }
                else {
                    self.loadingPics = false
                    pictureSubmitted = false
                }
            }
            
            
        })
    }
}







struct ImagePopupView: View {
    var images: [UIImage]
    @Binding var selectedImageIndex: Int
    @Environment(\.presentationMode) var presentationMode
    
    @GestureState private var dragOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Image(uiImage: images[selectedImageIndex])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .scaleEffect(1 - abs(dragOffset.width) / UIScreen.main.bounds.width * 0.5)
                    .animation(.easeInOut, value: dragOffset)
                    .offset(x: dragOffset.width, y: 0)
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.down")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.bottom,20)
                })
                
            }
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        let threshold = UIScreen.main.bounds.width / 3.0
                        if value.translation.width < -threshold && selectedImageIndex < images.count - 1 {
                            selectedImageIndex += 1
                        } else if value.translation.width > threshold && selectedImageIndex > 0 {
                            selectedImageIndex -= 1
                        }
                    }
            )
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .statusBar(hidden: true)
    }
    
}


