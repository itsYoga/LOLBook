//
//  ChampDetailView.swift
//  LOLBook
//
//  Created by Jesse Liang on 2024/11/10.
//

import SwiftUI

struct ChampDetailView: View {
    var champ: Datum
    @State var progressValue: Float = 0
    @State var progressValue1: Float = 0
    @State var progressValue2: Float = 0
    @State var progressValue3: Float = 0
    let spellsLabel: [String] = ["Passive:", "Q: ", "W: ", "E: ", "R: "]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                // MARK: - CHAMP IMAGE, TITLE AND NAME

                Group {
                    CacheAsyncImage(url: URL(string: "\(ddragon)/cdn/img/champion/centered/" + (champ.id) + "_0.jpg")!) { phase in
                        if let image = phase.image {
                            image.resizable()
                                .scaleEffect(2.5)
                                .scaledToFit()
                                .ignoresSafeArea()
                        } else if phase.error != nil {
                            Text("Failed loading the image")
                                .foregroundColor(.red)
                        } else {
                            ProgressView()
                                .frame(width: 200, height: 200)
                        }
                    }.padding(.bottom, 165)
                    Text(champ.name)
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                        .font(.system(size: 35))

                    Text(champ.title)
                        .foregroundColor(.primary)
                        .font(.system(size: 20))
                        .fontWeight(.light)
                }

                // MARK: - CHAMP TAGS --  TO REFACTOR

                HStack {
                    ForEach(champ.tags, id: \.self) { tag in

                        if tag == "Assassin" {
                            HStack {
                                Text(tag)
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                    .foregroundColor(.red)
                                SwiftUI.Image("7200_Domination")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        } else if tag == "Mage" {
                            HStack {
                                Text(tag)
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                                SwiftUI.Image("7202_Sorcery")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        } else if tag == "Marksman" {
                            HStack {
                                Text(tag)
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                    .foregroundColor(.yellow)
                                SwiftUI.Image("7201_Precision")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        } else if tag == "Tank" {
                            HStack {
                                Text(tag)
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                    .foregroundColor(.green)
                                SwiftUI.Image("7204_Resolve")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        } else if tag == "Support" {
                            HStack {
                                Text(tag)
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                    .foregroundColor(.teal)
                                SwiftUI.Image("7203_Whimsy")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        } else if tag == "Fighter" {
                            HStack {
                                Text(tag)
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                    .foregroundColor(.brown)
                                SwiftUI.Image("Conqueror")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                        }
                    }

                }.padding(.top, 5)

                // MARK: - CHAMP STATS -- TO REFACTOR

                Group {
                    HStack {
                        Text("Attack")
                            .fixedSize()
                        Spacer()
                        ProgressBar(value: $progressValue)
                            .frame(width: 250)
                        Text(String(champ.info.attack))
                            .fixedSize()
                    }.onAppear {
                        progressValue = Float(champ.info.attack) / 10
                    }

                    HStack {
                        Text("Defense")
                            .fixedSize()
                        Spacer()
                        ProgressBar(value: $progressValue1)
                            .frame(width: 250)
                        Text(String(champ.info.defense))
                            .fixedSize()
                    }.onAppear {
                        progressValue1 = Float(champ.info.defense) / 10
                    }

                    HStack {
                        Text("Magic")
                            .fixedSize()
                        Spacer()
                        ProgressBar(value: $progressValue2)
                            .frame(width: 250)
                        Text(String(champ.info.magic))
                            .fixedSize()
                    }.onAppear {
                        progressValue2 = Float(champ.info.magic) / 10
                    }

                    HStack {
                        Text("Difficulty")
                            .fixedSize()
                        Spacer()
                        ProgressBar(value: $progressValue3)
                            .frame(width: 250)
                        Text(String(champ.info.difficulty))
                            .fixedSize()
                    }.onAppear {
                        progressValue3 = Float(champ.info.difficulty) / 10
                    }

                }.padding(.top, 5)

                // MARK: - CHAMP LORE

                Text("Lore")
                    .fontWeight(.medium)
                    .font(.system(size: 25))
                    .padding(.top, 10)
                Text(champ.lore)
                    .fontWeight(.light)
                    .padding(.top, 2)

                // MARK: - CHAMP SPELLS

                Group {
                    Text("Spells")
                        .fontWeight(.medium)
                        .font(.system(size: 25))
                        .padding(.top, 10)

                    // Passive
                    HStack(spacing: 20) {
                        AsyncImage(url: URL(string: "https://ddragon.leagueoflegends.com/cdn/12.1.1/img/passive/" + (champ.passive.image.full))) { phase in
                            if let image = phase.image {
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(15)
                                    .overlay(RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.primary, lineWidth: 3))
                                // .shadow(radius: 5)
                            } else if phase.error != nil {
                                Color.red
                                    .frame(width: 80, height: 80)
                            } else {
                                ProgressView()
                                    .frame(width: 80, height: 80)
                            }
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                Text(spellsLabel[0])
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                                Text(champ.passive.name)
                                    .fontWeight(.bold)
                                Spacer()
                            }

                            // Replacing Occurrences was the easiest way to manage the HTML thing
                            Text(champ.passive.description.replacingOccurrences(of: "\\s?\\<[^>]*\\>", with: " ", options: .regularExpression))
                                .fontWeight(.light)
                        }
                    }

                    // Spells

                    ForEach(champ.spells.indices, id: \.self) { index in
                        HStack(spacing: 20) {
                            AsyncImage(url: URL(string: "https://ddragon.leagueoflegends.com/cdn/12.1.1/img/spell/" + (champ.spells[index].image.full))) { phase in
                                if let image = phase.image {
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(15)
                                        .overlay(RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.primary, lineWidth: 3))
                                } else if phase.error != nil {
                                    Color.red
                                        .frame(width: 80, height: 80)
                                } else {
                                    ProgressView()
                                        .frame(width: 80, height: 80)
                                }
                            }

                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    if index == 0 {
                                        Text("Q:")
                                            .fontWeight(.bold)
                                            .foregroundColor(.red)
                                    }
                                    if index == 1 {
                                        Text("W:")
                                            .fontWeight(.bold)
                                            .foregroundColor(.red)
                                    }
                                    if index == 2 {
                                        Text("E:")
                                            .fontWeight(.bold)
                                            .foregroundColor(.red)
                                    }
                                    if index == 3 {
                                        Text("R:")
                                            .fontWeight(.bold)
                                            .foregroundColor(.red)
                                    }
                                    Text(champ.spells[index].name)
                                        .fontWeight(.bold)
                                }
                                Text(champ.spells[index].spellDescription.replacingOccurrences(of: "\\s?\\<[^>]*\\>", with: " ", options: .regularExpression))
                                    .fontWeight(.light)
                            }
                        }
                    }
                }

                // MARK: - CHAMP TIPS

                Group {
                    Text("Tips")
                        .fontWeight(.medium)
                        .font(.system(size: 25))
                        .padding(.top, 10)

                    Text("When playing against:")
                        .fontWeight(.regular)
                        .font(.system(size: 18))
                        .foregroundColor(.red)
                        .padding(.bottom, 3)
                    if champ.enemytips.isEmpty {
                        Text("No tips for now")
                            .foregroundColor(.primary)
                            .fontWeight(.light)
                            .padding(.bottom, 3)
                    }
                    ForEach(champ.enemytips, id: \.self) { tips in
                        Text(tips)
                            .fontWeight(.light)
                        Divider()
                    }
                    Text("When playing with:")
                        .fontWeight(.regular)
                        .font(.system(size: 18))
                        .foregroundColor(.blue)
                        .padding(.bottom, 3)
                    if champ.allytips.isEmpty {
                        Text("No tips for now")
                            .foregroundColor(.primary)
                            .fontWeight(.light)
                            .padding(.top, 3)
                    }
                    ForEach(champ.allytips, id: \.self) { tips in
                        Text(tips)
                            .fontWeight(.light)
                        Divider()
                    }
                }

            }.padding()
        }
    }
}

struct ProgressBar: View {
    @Binding var value: Float

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemGray3))
                Rectangle()
                    .frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemRed))
            }
            .cornerRadius(45.0)
        }
    }
}
