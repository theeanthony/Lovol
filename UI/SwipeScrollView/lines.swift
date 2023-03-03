//
//  lines.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/1/22.
//

import SwiftUI

struct Matrix : Shape {
    
    func path(in rect: CGRect ) -> Path {
        var path = Path()
        

        path.move(to: CGPoint(x: 0, y: 570))
        //Left vertical bound
        path.addLine(to: CGPoint(x: 0, y: 475))
        //Curve
        path.addCurve(to: CGPoint(x: 500, y: 550), control1: CGPoint(x: 200, y: 570), control2: CGPoint(x: 50, y: 250))
        

        return path
        
        
    }
    
    
    
}


struct Matrix0 : Shape {
    
    func path(in rect: CGRect ) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 600))
        //Left vertical bound
        path.addLine(to: CGPoint(x: 0, y: 550))
        //Curve
        path.addCurve(to: CGPoint(x: 500, y: 650), control1: CGPoint(x: 50, y: 500), control2: CGPoint(x: 250, y: 450))
                

        return path
        
        
    }
    
    
    
}
struct Matrix1 : Shape {
    
    func path(in rect: CGRect ) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 400))
        path.addLine(to: CGPoint(x: 0, y: 400))
        path.addCurve(to: CGPoint(x: 650, y: 450), control1: CGPoint(x: 150, y: 350), control2: CGPoint(x:100, y: 300))
        path.addLine(to: CGPoint(x: 450, y: 0))


        return path
        
        
    }
    
    
}
struct Matrix2 : Shape {
    
    func path(in rect: CGRect ) -> Path {
        var path = Path()
        path.move(to: CGPoint(x:250, y: 519))
        //Left vertical bound
        path.addLine(to: CGPoint(x: 250, y: 519))
        //Curve
        path.addCurve(to: CGPoint(x: 250, y: 519), control1: CGPoint(x: 500, y: 660), control2: CGPoint(x: 630, y: 530))

        return path
        
        
    }
    
    
}
struct Matrix3 : Shape {
    
    func path(in rect: CGRect ) -> Path {
        var path = Path()


        path.move(to: CGPoint(x: 0, y: 690))
        //Left vertical bound
        path.addLine(to: CGPoint(x: 0, y: 600))
        //Curve
        path.addCurve(to: CGPoint(x: 600, y: 730), control1: CGPoint(x: 100, y: 600), control2: CGPoint(x: 400, y: 540))

        return path
        
        
    }
    
    
}
struct Matrix4 : Shape {
    
    func path(in rect: CGRect ) -> Path {
        var path = Path()



        path.move(to: CGPoint(x: 0, y: 800))
        //Left vertical bound
        path.addLine(to: CGPoint(x: 0, y: 690))
        //Curve
        path.addCurve(to: CGPoint(x: 600, y: 850), control1: CGPoint(x: 50, y: 610), control2: CGPoint(x: 400, y: 640))
        path.addLine(to: CGPoint(x: 0, y: 1050))

        return path
        
        
    }
    
    
}
struct Matrix5 : Shape {
    
    func path(in rect: CGRect ) -> Path {
        var path = Path()


//        path.move(to: CGPoint(x: 50, y: 800))
//        //Left vertical bound
//        path.addLine(to: CGPoint(x: 0, y: 800))
//        //Curve
//        path.addCurve(to: CGPoint(x: 600, y: 1450), control1: CGPoint(x: 50, y: 690), control2: CGPoint(x: 400, y: 640))
//        path.addLine(to: CGPoint(x: 0, y: 1050))
        path.move(to: CGPoint(x: 0, y: 800))
        //Left vertical bound
        path.addLine(to: CGPoint(x: 0, y: 850))
        //Curve
        path.addCurve(to: CGPoint(x: 600, y: 1450), control1: CGPoint(x: 50, y: 690), control2: CGPoint(x: 400, y: 640))
        path.addLine(to: CGPoint(x: 0, y: 1050))

        return path
        
        
    }
    
    
}



struct lines: View {

    var body: some View {
        
        
        ZStack{
            Group{
                AppColor.almondBackGround
                    .clipShape(Matrix())
                Matrix()
                    .stroke(.black, lineWidth: 5)
                
                AppColor.pinkPurpleButtonOutline
                    .clipShape(Matrix0())
                Matrix0()
                    .stroke(.black, lineWidth: 5)
                
                Color.white
                    .clipShape(Matrix2())
                Matrix2()
                    .stroke(.black, lineWidth: 5)
                
                AppColor.almondBackGround
                    .clipShape(Matrix3())
                Matrix3()
                    .stroke(.black, lineWidth: 5)
            }
            Group{
                AppColor.purpleButtonColor
                    .clipShape(Matrix4())
                Matrix4()
                    .stroke(.black, lineWidth: 5)
                
                Color.white
                    .clipShape(Matrix5())
                Matrix5()
                    .stroke(.black, lineWidth: 5)
            }
        }
            
        
    }
           

    
}

struct lines_Previews: PreviewProvider {
    static var previews: some View {
        lines()
    }
}
