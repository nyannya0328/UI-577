//
//  Home.swift
//  UI-577
//
//  Created by nyannyan0328 on 2022/06/03.
//

import SwiftUI

struct Home: View {
    @Namespace var animation
    @State var isExpanded : Bool = false
    @State var expandProfile : Profile?
    @State var loadExpandContent : Bool = false
    @State var offset : CGSize = .zero
    var body: some View {
        NavigationView{
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing:12){
                    
                    ForEach(profiles){pro in
                        
                        
                        CardView(pro: pro)
                    }
                }
                .padding()
            }
            .navigationTitle("Whats Up")
        }
          .frame(maxWidth: .infinity,alignment: .center)
        .overlay(content: {
            
            Rectangle()
                .fill(.black)
                .frame(maxWidth: .infinity,alignment: .center)
                .opacity(isExpanded ? 1 : 0)
                .opacity(offsetHeight())
                .ignoresSafeArea()
                 
        })
        .overlay {
            
            if let expandProfile = expandProfile,isExpanded {
                
                
                ExpandView(pro: expandProfile)
                
            }
        }
    }
    
    func offsetHeight()->CGFloat{
        
        let progress = offset.height / 100
        
        if offset.height < 0{
            
            return 1
        }
        else{
            
            return 1 - (progress < 1 ? progress : 1)
        }
        
    }
    
    @ViewBuilder
    func ExpandView(pro : Profile)->some View{
        
        
        VStack{
            
            
            GeometryReader{proxy in
                
                
                 let size = proxy.size
                
                Image(pro.profilePicture)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .offset(y: loadExpandContent ? 0 : size.height)
                    .offset(y:loadExpandContent ?  offset.height : .zero)
                    .gesture(
                    
                    
                        DragGesture().onChanged({ value in
                            
                            offset = value.translation
                        })
                        .onEnded({ value in
                            
                            
                            let height = value.translation.height
                            
                            
                            if height < 0 && height < 100{
                                
                                
                                withAnimation(.easeInOut(duration: 4)){
                                    
                                    loadExpandContent = false
                                }
                                
                                withAnimation(.easeInOut(duration: 4).delay(0.05)){
                                    
                                    isExpanded  = false
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                                    
                                    offset = .zero
                                }
                                
                                
                            }
                            else{
                                
                                offset = .zero
                            }
                        })
                    
                    )
                
            }
            .matchedGeometryEffect(id: pro.id, in: animation)
            .frame(height: 300)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .top) {
            
            Button {
                
                withAnimation(.easeInOut(duration: 4)){
                    
                    loadExpandContent = false
                }
                
                withAnimation(.easeInOut(duration: 4).delay(0.05)){
                    
                    isExpanded  = false
                }
                
                
            } label: {
                
                Image(systemName: "arrow.left")
                    .font(.callout.weight(.bold))
                
                
                
                Text(pro.userName)
                    .font(.caption2.weight(.semibold))
                
                
                Spacer(minLength: 10)
                 
                
                
                
            }
            .padding(.horizontal)
            .foregroundColor(.white)
            .opacity(loadExpandContent ? 1 : 0)
            .opacity(offsetHeight())
          
            

        }
        .transition(.offset(x: 0, y: -1))
        .onAppear {
            
            withAnimation(.easeInOut(duration: 4)){
                
                loadExpandContent = true
            }
        }
        
        
    }
    @ViewBuilder
    func CardView(pro : Profile)->some View{
        
        HStack{
            
            VStack{
                
                if expandProfile?.id == pro.id && isExpanded{
                    
                    Image(pro.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(0)
                        .opacity(0)
                }
                
                else{
                    
                    
                    Image(pro.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                       
                        .matchedGeometryEffect(id: pro.id, in: animation)
                        .cornerRadius(25)
                    
                    
                }
                
                
            }
            .onTapGesture {
                
                
                withAnimation(.easeInOut(duration: 5)){
                    
                    expandProfile = pro
                    isExpanded = true
                }
            }
            
            
            VStack(alignment: .leading, spacing: 15) {
                
                
                Text(pro.userName)
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(.black)
                
                Text(pro.lastMsg)
                    .font(.callout)
                    .foregroundColor(.gray)
                
                
                
            }
              .frame(maxWidth: .infinity,alignment: .leading)
            
            
            Text(pro.lastMsg)
                .font(.callout.weight(.semibold))
                .opacity(0.8)
        }
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
