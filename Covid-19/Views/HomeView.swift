//
//  HomeView.swift
//  Covid-19
//
//  Created by Yauheni Bunas on 5/30/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State var index = 0
    @State var main: MainData!
    @State var daily: [Daily] = []
    @State var last: Int = 1
    @State var country: String = "belarus"
    @State var alert: Bool = false
    
    var allDaysURL = "https://corona.lmao.ninja/v2/all?today"
    var allDaysCountryURL = "https://corona.lmao.ninja/v2/countries/%@?yesterday=false"
    
    var weaklyURL = "https://corona.lmao.ninja/v2/historical/all?lastdays=7"
    var weaklyCountryURL = "https://corona.lmao.ninja/v2/historical/%@?lastdays=7"
    
    var body: some View {
        VStack {
            if self.main != nil && !self.daily.isEmpty {
                VStack {
                    VStack(spacing: 18) {
                        HStack {
                            Text("Statistics")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                self.Dialog()
                            }) {
                                Text(self.country.uppercased())
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 15)
                        
                        HStack {
                            Button(action: {
                                self.index = 0
                                self.main = nil
                                self.daily.removeAll()
                                self.getAllDaysData()
                                self.getWeeklyData()
                            }) {
                                Text("My Country")
                                    .foregroundColor(self.index == 0 ? .black : .white)
                                    .padding(.vertical, 12)
                                    .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                            }
                            .background(self.index == 0 ? Color.white : Color.clear)
                            .clipShape(Capsule())
                            
                            Button(action: {
                                self.index = 1
                                self.main = nil
                                self.daily.removeAll()
                                self.getAllDaysData()
                                self.getWeeklyData()
                            }) {
                                Text("Global")
                                    .foregroundColor(self.index == 1 ? .black : .white)
                                    .padding(.vertical, 12)
                                    .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                            }
                            .background(self.index == 1 ? Color.white : Color.clear)
                            .clipShape(Capsule())
                        }
                        .background(Color.black.opacity(0.25))
                        .clipShape(Capsule())
                        .padding(.top, 10)
                        
                        HStack(spacing:15) {
                            VStack(spacing: 12) {
                                Text("Affected")
                                    .fontWeight(.bold)
                                
                                Text("\(self.main.cases)")
                                    .fontWeight(.bold)
                                    .font(.title)
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                            .background(Color("affected"))
                            .cornerRadius(12)
                            
                            VStack(spacing: 12) {
                                Text("Death")
                                    .fontWeight(.bold)
                                
                                Text("\(self.main.deaths)")
                                    .fontWeight(.bold)
                                    .font(.title)
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                            .background(Color("death"))
                            .cornerRadius(12)
                        }
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        
                        HStack(spacing:15) {
                            VStack(spacing: 12) {
                                Text("Recovered")
                                    .fontWeight(.bold)
                                
                                Text("\(self.main.recovered)")
                                    .fontWeight(.bold)
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width / 3) - 30)
                            .background(Color("recovered"))
                            .cornerRadius(12)
                            
                            VStack(spacing: 12) {
                                Text("Active")
                                    .fontWeight(.bold)
                                
                                Text("\(self.main.active)")
                                    .fontWeight(.bold)
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width / 3) - 30)
                            .background(Color("active"))
                            .cornerRadius(12)
                            
                            VStack(spacing: 12) {
                                Text("Serius")
                                    .fontWeight(.bold)
                                
                                Text("\(self.main.critical)")
                                    .fontWeight(.bold)
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width / 3) - 30)
                            .background(Color("serious"))
                            .cornerRadius(12)
                        }
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 45)
                    .background(Color("bg"))
                    
                    VStack(spacing: 15) {
                        HStack {
                            Text("Last 7 Days")
                                .font(.title)
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                        .padding(.top)
                        
                        HStack {
                            ForEach(self.daily) { day in
                                VStack(spacing: 10) {
                                    Text("\(day.cases / 1000)K")
                                        .lineLimit(1)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    GeometryReader { g in
                                        VStack {
                                            Spacer(minLength: 0)
                                            
                                            Rectangle()
                                                .fill(Color("death"))
                                                .frame(width: 15, height: CGFloat.getGeometryReaderHeight(value: day.cases, lastValue: self.last, height: g.frame(in: .global).height))
                                        }
                                    }
                                    
                                    Text("\(day.day)")
                                        .lineLimit(1)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.bottom, -30)
                    .offset(y: -30)
                }
            } else {
                Indicator()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .alert(isPresented: self.$alert, content: {
            Alert(title: Text("Error"), message: Text("Invalid Country Name"), dismissButton: .destructive(Text("Ok")))
        })
        .onAppear {
            self.getAllDaysData()
            self.getWeeklyData()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension HomeView {
    func getAllDaysData() {
        var mainDataUrl = ""
        
        if self.index == 0 {
            mainDataUrl = NSString(format: self.allDaysCountryURL as NSString, self.country) as String
        } else {
            mainDataUrl = self.allDaysURL
        }
        
        let mainDataSession = URLSession(configuration: .default)
        
        mainDataSession.dataTask(with: URL(string: mainDataUrl)!) { (data, _, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                
                return
            }
            
            let json = try! JSONDecoder().decode(MainData.self, from: data!)
            
            self.main = json
        }
        .resume()
    }
    
    func getWeeklyData() {
        var weeklyDataUrl = ""
        
        if self.index == 0 {
            weeklyDataUrl = NSString(format: self.weaklyCountryURL as NSString, self.country) as String
        } else {
            weeklyDataUrl = weaklyURL
        }
        
        let weeklyDataSession = URLSession(configuration: .default)
        
        weeklyDataSession.dataTask(with: URL(string: weeklyDataUrl)!) { (data, _, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                
                return
            }
            
            var count = 0
            var cases: [String: Int] = [:]
            
            if self.index == 0 {
                let json = try! JSONDecoder().decode(MyCountry .self, from: data!)
                cases = json.timeline["cases"]!
            } else {
                let json = try! JSONDecoder().decode(Global .self, from: data!)
                cases = json.cases
            }
            
            for day in cases {
                self.daily.append(Daily(id: count, day: day.key, cases: day.value))
                count += 1
            }
            
            self.daily.sort { (t1, t2) -> Bool in
                if t1.day < t2.day {
                    return true
                }
                
                return false
            }
            
            self.last = self.daily.last!.cases
        }
        .resume()
    }
    
    func Dialog() {
        let alert = UIAlertController(title: "Country", message: "Type a Country", preferredStyle: .alert)
        
        alert.addTextField { (_) in
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            for country in countryList {
                if country.lowercased() == alert.textFields![0].text!.lowercased() {
                    self.country = country.lowercased()
                    self.main = nil
                    self.daily.removeAll()
                    self.getAllDaysData()
                    self.getWeeklyData()
                    
                    return
                }
            }
            
            self.alert.toggle()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
