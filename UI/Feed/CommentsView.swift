//
//  CommentsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/30/22.
//

import SwiftUI

struct CommentsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(.white)
                  
              }
          }
      }
    @EnvironmentObject private var eventViewModel: EventViewModel
    @State private var typingMessage: String = ""
    
    @State private var showCommentError : Bool = false
    @State private var editableComments : [CommentModel] = []
    @State private var loading : Bool = false
    @State private var showLoadingError : Bool = false

    var eventId : String 
    var body: some View {
        VStack{
            Spacer()
            VStack{

            if loading {
                ProgressView()
            }else{
                    Spacer()
                    ScrollView{
                        ForEach(editableComments.indices, id:\.self){index in
                            
                            CommentView(comment: editableComments[index])
                                .padding(.horizontal,10)
                                .padding(.bottom,5)
                            
                        }
                        
                    }
                    HStack {
                        TextField("", text: $typingMessage).padding(.leading,5).placeholder(when: typingMessage.isEmpty, placeholder: {
                            Text("Write Something...").foregroundColor(.white).opacity(0.8)
                        })
                            .padding(.vertical,10)
                            .padding(.leading,5)
                            .foregroundColor(.white)
                        //                      .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(minHeight: CGFloat(30))
                            .background(RoundedRectangle(cornerRadius: 30).stroke(AppColor.lovolDarkPurple, lineWidth: 1))
                        if(!typingMessage.isEmpty){
                            Button(action: sendMessage) {
                                Image(systemName: "paperplane.fill")
                                    .padding(8)
                                    .foregroundColor(.white)
                                    .background(Circle().fill(AppColor.lovolPinkish))
                            }
                        }
                        
                    }
                    .frame(minHeight: CGFloat(50)).padding([.trailing, .leading])
                    .padding(.bottom,5)
                }
            }

//            .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolTan).opacity(0.6))
            .padding(.vertical,10)
            .padding(.top,30)
        }
        .overlay(
            
            VStack{
                HStack{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName:"xmark")
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(AppColor.lovolDark)).opacity(0.6)
                    }

                    Spacer()
                }
                .padding(.leading,15)
                Spacer()
            }
        )
        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .background(BackgroundView())

        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("")
//        .ignoresSafeArea(.keyboard)
        .onAppear(perform: fillComments)
        .alert("Could not upload comment, please try again later.", isPresented: $showCommentError, actions: {
            Button("OK", role: .cancel, action: {
                
            })
        })
        .alert("Could not upload comment, please try again later.", isPresented: $showLoadingError, actions: {
            Button("OK", role: .cancel, action: {
                presentationMode.wrappedValue.dismiss()

            })
        })
    }
    private func fillComments(){
        eventViewModel.fetchComments(id: eventId) { result in
            switch result {
            case .success(let fetchedComments) :
                self.editableComments = fetchedComments
                loading = false
            case .failure(let error):
                print("error fetching comments \(error)")
                showLoadingError = true
            }
        }
//        editableComments = comments
    }
    private func sendMessage(){
        
        eventViewModel.comment(comment: typingMessage, id: eventId) { result in
            switch result {
            case .success(let comment):
                self.editableComments.append(comment)
            case .failure(let error):
                print("error writing comment \(error)")
                
                showCommentError = false
            }
        }
            typingMessage = ""
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView( eventId: "")
    }
}
