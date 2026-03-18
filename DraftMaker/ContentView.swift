//
//  ContentView.swift
//  DraftMaker
//


import SwiftUI

struct ContentView: View {
    @State private var selectedPurpose = "シフト変更をお願いしたい"
    @State private var customPurposeText = ""
    @State private var selectedRelation = "バイトの店長"
    @State private var customRelationText = ""
    @State private var generatedText = ""
    @State private var isLoading = false
    @State private var showCopiedAlert = false
    
    let purposes = [
        ("シフト変更", "calendar.badge.clock", "シフト変更をお願いしたい"),
        ("誘いを断る", "hand.raised.fill", "角を立てずに誘いを断りたい"),
        ("遅刻の連絡", "clock.badge.exclamationmark", "遅刻の連絡をしたい"),
        ("相談事", "bubble.left.and.bubble.right.fill", "相談事がある"),
        ("その他", "pencil", "その他（自分で入力）")
    ]
    let relations = [
        ("バイトの店長", "person.crop.circle.badge.checkmark"),
        ("ゼミの先輩", "graduationcap.fill"),
        ("仲の良い友達", "face.smiling.fill"),
        ("取引先", "briefcase.fill"),
        ("その他", "pencil")
    ]
    
    // キーボードのフォーカス状態を管理
    @FocusState private var isCustomTextFocused: Bool
    @FocusState private var isCustomRelationFocused: Bool
    @FocusState private var isTextEditorFocused: Bool

    var body: some View {
        NavigationView {
            ZStack {
                // 背景: やさしいグラデーション
                LinearGradient(
                    gradient: Gradient(colors: [Color.cuteBackground, Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                // タップでキーボードを閉じる
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isCustomTextFocused = false
                        isCustomRelationFocused = false
                        isTextEditorFocused = false
                    }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {
                        
                        // --- 目的を選ぶセクション ---
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(.cutePrimary)
                                Text("どうしたの？")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.cuteText)
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    Spacer().frame(width: 4)
                                    ForEach(purposes, id: \.0) { purpose in
                                        SelectionCard(
                                            icon: purpose.1,
                                            text: purpose.0,
                                            isSelected: selectedPurpose == purpose.2
                                        ) {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                                selectedPurpose = purpose.2
                                                if selectedPurpose != "その他（自分で入力）" {
                                                    isCustomTextFocused = false
                                                }
                                            }
                                        }
                                    }
                                    Spacer().frame(width: 4)
                                }
                            }
                            
                            // "その他"が選ばれた時の自由入力欄
                            if selectedPurpose == "その他（自分で入力）" {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("💬 伝えたい内容を自由に書いてね")
                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                        .foregroundColor(.cutePrimary)
                                        .padding(.leading, 4)
                                    
                                    TextField("例：明日の15時に訪問したいことを伝えたい", text: $customPurposeText, axis: .vertical)
                                        .focused($isCustomTextFocused)
                                        .font(.system(size: 16, design: .rounded))
                                        .lineLimit(3...6)
                                        .padding(14)
                                        .background(Color.white)
                                        .cornerRadius(16)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.cutePrimary.opacity(0.3), lineWidth: 2)
                                        )
                                        .shadow(color: .cuteShadow, radius: 4, x: 0, y: 2)
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 8)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        
                        // --- 相手を選ぶセクション ---
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "person.2.fill")
                                    .foregroundColor(.cutePrimary)
                                Text("だれに送る？")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.cuteText)
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    Spacer().frame(width: 4)
                                    ForEach(relations, id: \.0) { relation in
                                        SelectionCard(
                                            icon: relation.1,
                                            text: relation.0,
                                            isSelected: selectedRelation == relation.0
                                        ) {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                                selectedRelation = relation.0
                                                if selectedRelation != "その他" {
                                                    isCustomRelationFocused = false
                                                }
                                            }
                                        }
                                    }
                                    Spacer().frame(width: 4)
                                }
                            }
                            
                            // "その他"が選ばれた時の自由入力欄
                            if selectedRelation == "その他" {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("💬 誰に送るか教えてね")
                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                        .foregroundColor(.cutePrimary)
                                        .padding(.leading, 4)
                                    
                                    TextField("例：サークルの後輩", text: $customRelationText)
                                        .focused($isCustomRelationFocused)
                                        .font(.system(size: 16, design: .rounded))
                                        .padding(14)
                                        .background(Color.white)
                                        .cornerRadius(16)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.cutePrimary.opacity(0.3), lineWidth: 2)
                                        )
                                        .shadow(color: .cuteShadow, radius: 4, x: 0, y: 2)
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 8)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        
                        // --- 作成ボタン ---
                        VStack(spacing: 12) {
                            // その他が選ばれている場合の案内表示
                            if selectedPurpose == "その他（自分で入力）" || selectedRelation == "その他" {
                                HStack {
                                    Image(systemName: "info.circle.fill")
                                    Text("直接AIにお願いできる「プロンプト」を作成します！")
                                        .font(.system(size: 13, weight: .bold, design: .rounded))
                                }
                                .foregroundColor(.cutePrimary)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.cutePrimary.opacity(0.1))
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                isCustomTextFocused = false
                                isCustomRelationFocused = false
                                generateDraft()
                                // 少し強めの振動フィードバック
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                            }) {
                                HStack {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .padding(.trailing, 4)
                                        Text("考え中...")
                                            .font(.system(size: 18, weight: .bold, design: .rounded))
                                    } else {
                                        Image(systemName: "magic")
                                            .font(.system(size: 18, weight: .bold))
                                        Text("サクッとたたき台を作る！")
                                            .font(.system(size: 18, weight: .bold, design: .rounded))
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    Group {
                                        if isLoading {
                                            Color.gray.opacity(0.4)
                                        } else {
                                            LinearGradient(gradient: Gradient(colors: [Color.cutePrimary, Color(red: 1.0, green: 0.5, blue: 0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                        }
                                    }
                                )
                                .foregroundColor(.white)
                                .cornerRadius(30)
                                .shadow(color: isLoading ? .clear : Color.cutePrimary.opacity(0.5), radius: 10, x: 0, y: 5)
                                .scaleEffect(isLoading ? 0.98 : 1.0)
                            }
                            .disabled(isLoading || 
                                     (selectedPurpose == "その他（自分で入力）" && customPurposeText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ||
                                     (selectedRelation == "その他" && customRelationText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty))
                            
                            // AIに丸投げボタン
                            Button(action: {
                                isCustomTextFocused = false
                                isCustomRelationFocused = false
                                openAIForDraft()
                            }) {
                                HStack {
                                    Image(systemName: "sparkles")
                                    Text("AIにしっかり考えてもらう")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.white)
                                .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8)) // かわいい紫
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(red: 0.4, green: 0.3, blue: 0.8), lineWidth: 1.5)
                                )
                                .shadow(color: .cuteShadow, radius: 5, x: 0, y: 2)
                            }
                            .disabled(isLoading || 
                                     (selectedPurpose == "その他（自分で入力）" && customPurposeText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ||
                                     (selectedRelation == "その他" && customRelationText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty))
                        }

                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // --- 結果表示エリア ---
                        if !generatedText.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "envelope.open.fill")
                                        .foregroundColor(.cutePrimary)
                                    Text("完成したメッセージ")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundColor(.cuteText)
                                }
                                
                                VStack(spacing: 0) {
                                    // 編集案内
                                    HStack {
                                        Image(systemName: "pencil.line")
                                        Text("枠内をタップしてそのまま編集できます！")
                                            .font(.system(size: 13, weight: .medium, design: .rounded))
                                        Spacer()
                                    }
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 12)
                                    .padding(.bottom, 4)
                                    
                                    // 吹き出し風のデザイン・目立つ編集エリア
                                    TextEditor(text: $generatedText)
                                        .focused($isTextEditorFocused)
                                        .font(.system(size: 16, design: .rounded))
                                        .foregroundColor(.cuteText)
                                        .frame(minHeight: 180)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .scrollContentBackground(.hidden)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.white)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(isTextEditorFocused ? Color.cutePrimary : Color.cutePrimary.opacity(0.3), lineWidth: isTextEditorFocused ? 2 : 1)
                                        )
                                        .padding([.horizontal, .bottom], 12)
                                        .toolbar {
                                            ToolbarItemGroup(placement: .keyboard) {
                                                Spacer()
                                                Button("完了") {
                                                    isTextEditorFocused = false
                                                    isCustomTextFocused = false
                                                    isCustomRelationFocused = false
                                                }
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.cutePrimary)
                                            }
                                        }
                                    
                                    Divider()
                                        .background(Color.cuteBackground)
                                    
                                    // アクションボタン（コピー & シェア）
                                    HStack(spacing: 0) {
                                        Button(action: {
                                            UIPasteboard.general.string = generatedText
                                            withAnimation { showCopiedAlert = true }
                                            let generator = UINotificationFeedbackGenerator()
                                            generator.notificationOccurred(.success)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                withAnimation { showCopiedAlert = false }
                                            }
                                        }) {
                                            HStack {
                                                Image(systemName: showCopiedAlert ? "checkmark.circle.fill" : "doc.on.doc.fill")
                                                Text(showCopiedAlert ? "コピーしました" : "コピー")
                                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 16)
                                            .foregroundColor(showCopiedAlert ? .green : .cutePrimary)
                                        }
                                        
                                        Divider()
                                            .frame(height: 30)
                                            .background(Color.cuteBackground)
                                        
                                        ShareLink(item: generatedText) {
                                            HStack {
                                                Image(systemName: "square.and.arrow.up")
                                                Text("送る")
                                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 16)
                                            .foregroundColor(.cutePrimary)
                                        }
                                    }
                                    .background(Color.cuteCard)
                                }
                                .background(Color.cuteCard)
                                .cornerRadius(24)
                                .shadow(color: .cuteShadow.opacity(0.8), radius: 15, x: 0, y: 8)
                            }
                            .padding(.horizontal, 20)
                            .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .opacity))
                        }
                        
                        Spacer(minLength: 60)
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationBarHidden(true) // ナビゲーションバーを消してより画面を広く使う
        }
    }
    
    // AIバックエンドへの通信モック
    func generateDraft() {
        withAnimation {
            isLoading = true
            generatedText = ""
            showCopiedAlert = false
        }
        // 実際にAIに渡す用の目的文字列
        let finalPurpose = selectedPurpose == "その他（自分で入力）" ? customPurposeText : selectedPurpose
        let finalRelation = selectedRelation == "その他" ? customRelationText : selectedRelation
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.spring()) {
                isLoading = false
                
                
                if selectedPurpose == "その他（自分で入力）" || selectedRelation == "その他" {
                    generatedText = """
                    あなたは丁寧なコミュニケーションが得意なアシスタントです。
                    以下の条件で、LINEやメッセージアプリで送るための文章を作成してください。
                    
                    【相手】: \(finalRelation)
                    【伝えたい内容】: \(finalPurpose)
                    
                    【条件】
                    - 相手との関係性に合わせた適切なトーン（敬語・フランクなど）で書いてください。
                    - 〇〇（自分の名前）や×月×日（日付）など、後から編集しやすいようにプレースホルダーを入れてください。
                    - そのままコピペして使えるように、余計な挨拶は省き、メッセージの本文のみを出力してください。
                    """
                } else if selectedPurpose == "シフト変更をお願いしたい" {
                    switch selectedRelation {
                    case "バイトの店長": generatedText = "お疲れ様です。〇〇です。\n大変申し訳ないのですが、×月×日のシフトについてご相談があります。\n急な体調不良（または大学の都合など）のため、お休みをいただいてもよろしいでしょうか？\nご迷惑をおかけして大変申し訳ありません。ご検討のほどよろしくお願いいたします。"
                    case "ゼミの先輩": generatedText = "お疲れ様です、〇〇です。\n大変申し訳ありませんが、×月×日のシフト（予定）に入ることが難しくなってしまいました。\n急な変更でご迷惑をおかけしてしまい、本当にすみません。\n後ほど改めてご相談させてください。"
                    case "仲の良い友達": generatedText = "ごめん！×月×日のシフトなんだけど、どうしても外せない用事（または体調不良）で行けなくなっちゃって💦\n急で本当に申し訳ないんだけど、もし可能だったら代わってもらえたりしないかな...？\n無理なら全然大丈夫なので教えて！🙇‍♀️"
                    case "取引先": generatedText = "いつもお世話になっております。〇〇株式会社の△△です。\n大変恐縮ですが、×月×日に予定しておりましたお打ち合わせの日程につきまして、急遽変更をお願いできないかと存じます。\nこちらの都合で誠に申し訳ございませんが、別日程にて改めて調整させていただけないでしょうか。\n何卒よろしくお願い申し上げます。"
                    default: generatedText = ""
                    }
                } else if selectedPurpose == "角を立てずに誘いを断りたい" {
                    switch selectedRelation {
                    case "バイトの店長": generatedText = "お疲れ様です。〇〇です。お誘いいただきありがとうございます。\n大変恐縮なのですが、その日はどうしても外せない用事があり、参加することができません。\nせっかくお声がけいただいたのに申し訳ありません。またの機会がありましたら、よろしくお願いいたします。"
                    case "ゼミの先輩": generatedText = "お疲れ様です！お誘いありがとうございます。\nすごく行きたいのですが、あいにくその日は予定が入ってしまっておりまして...😭\nせっかくお声がけいただいたのに本当にすみません！また次回ぜひよろしくお願いします！"
                    case "仲の良い友達": generatedText = "誘ってくれてありがとう！✨\nめっちゃ行きたいんだけど、その日どうしても外せない用事があって行けないんだ...ごめんね😭\nまた今度絶対遊ぼう！！"
                    case "取引先": generatedText = "いつも大変お世話になっております。〇〇株式会社の△△です。\nこの度はお食事（お打ち合わせ等）にお誘いいただき、誠にありがとうございます。\n大変恐縮ではございますが、あいにくその日は先約がございまして、お伺いすることが難しい状況でございます。\nせっかくの機会をいただきながら誠に申し訳ございません。またの機会がございましたら、是非よろしくお願い申し上げます。"
                    default: generatedText = ""
                    }
                } else if selectedPurpose == "遅刻の連絡をしたい" {
                    switch selectedRelation {
                    case "バイトの店長": generatedText = "お疲れ様です。〇〇です。大変申し訳ありません。\n現在そちらに向かっているのですが、電車の遅延（または交通渋滞など）の影響で、到着が〇〇時〇〇分頃になってしまいそうです。\nご迷惑をおかけして誠に申し訳ございません。急いで向かいます。"
                    case "ゼミの先輩": generatedText = "お疲れ様です、〇〇です。本当にすみません。\n今向かっているのですが、少し到着が遅れてしまいそうです...！\n〇〇分くらいには着けると思います。ご迷惑をおかけして申し訳ありません🙇‍♀️"
                    case "仲の良い友達": generatedText = "ごめん！！今向かってるんだけど、〇〇分くらい遅刻しそうです💦\n本当にごめんね！急いで行く！！🏃‍♀️💨"
                    case "取引先": generatedText = "いつも大変お世話になっております。〇〇株式会社の△△です。\n本日〇〇時よりお約束しておりましたが、交通機関の乱れにより、到着が〇〇分ほど遅れる見込みとなっております。\nお約束のお時間に遅れてしまい、誠に申し訳ございません。\n到着次第、すぐにご連絡（またはお伺い）させていただきます。"
                    default: generatedText = ""
                    }
                } else if selectedPurpose == "相談事がある" {
                    switch selectedRelation {
                    case "バイトの店長": generatedText = "お疲れ様です。〇〇です。\nお忙しいところ申し訳ありません。\n今後のシフト（または業務の進め方など）について少しご相談させていただきたいことがあるのですが、お手すきの際にお時間を少し頂戴することは可能でしょうか？\nよろしくお願いいたします。"
                    case "ゼミの先輩": generatedText = "お疲れ様です、〇〇です！\n〇〇の件で少し先輩にご相談したいことがあるのですが...！\nもしお時間ある時があれば、少しだけお話聞かせていただけないでしょうか？🙇‍♀️"
                    case "仲の良い友達": generatedText = "お疲れー！\nちょっと相談したいこと（聞いてほしいこと）があるんだけど、今週末とか時間あったりする？🥺\n暇な時で全然大丈夫だから、また教えてー！"
                    case "取引先": generatedText = "いつも大変お世話になっております。〇〇株式会社の△△です。\n現在進行中の〇〇の案件につきまして、少しご相談させていただきたくご連絡いたしました。\nお忙しいところ恐縮ですが、明日以降で少しお打ち合わせのお時間を頂戴できないでしょうか？\nご都合の良い候補日時をいくつかいただけますと幸甚です。"
                    default: generatedText = ""
                    }
                } else {
                    generatedText = "お疲れ様です。〇〇です。\n\n（「\(finalPurpose)」に関する、\(finalRelation)向けの生成テキストがここに入ります。）"
                }
            }
        }
    }
  
    // WebのAIサービスを開き、プロンプトをクリップボードにコピー
    func openAIForDraft() {
        let finalPurpose = selectedPurpose == "その他（自分で入力）" ? customPurposeText : selectedPurpose
        let finalRelation = selectedRelation == "その他" ? customRelationText : selectedRelation
        
        let prompt = """
        あなたは丁寧なコミュニケーションが得意なアシスタントです。
        以下の条件で、LINEやメッセージアプリで送るための文章を作成してください。
        
        【相手】: \(finalRelation)
        【伝えたい内容】: \(finalPurpose)
        
        【条件】
        - 相手との関係性に合わせた適切なトーン（敬語・フランクなど）で書いてください。
        - 〇〇（自分の名前）や×月×日（日付）など、後から編集しやすいようにプレースホルダーを入れてください。
        - そのままコピペして使えるように、余計な挨拶（「承知しました」など）は省き、メッセージの本文のみを出力してください。
        """
        
        UIPasteboard.general.string = prompt
        
        if let url = URL(string: "https://duckduckgo.com/chat") {
            UIApplication.shared.open(url)
        }
    }
}

// 角丸を個別に指定するための拡張
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// 選択用のカスタムカードコンポーネント
struct SelectionCard: View {
    var icon: String
    var text: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : .cutePrimary)
                
                Text(text)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(isSelected ? .white : .cuteText)
                    .lineLimit(1)
            }
            .frame(width: 110, height: 90)
            .background(isSelected ? Color.cutePrimary : Color.cuteCard)
            .cornerRadius(20)
            .shadow(color: isSelected ? Color.cutePrimary.opacity(0.4) : Color.cuteShadow, radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.cutePrimary : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// ふわふわ浮くようなアニメーションのモディファイア
struct FloatingEffect: ViewModifier {
    @State private var isFloating = false

    func body(content: Content) -> some View {
        content
            .offset(y: isFloating ? -5 : 5)
            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isFloating)
            .onAppear {
                isFloating = true
            }
    }
}

#Preview {
    ContentView()
}
