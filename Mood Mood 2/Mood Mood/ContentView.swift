import SwiftUI
import Charts
// Data model representing a "Mood Moods"
struct Moods: Identifiable {
    var id = UUID()
    var emotion: Color
    var Size: String
    var workinghour: Double
    var date: Date  // Added a date property
//    @State var Positive :Int = 0
//    @State var Negative :Int = 0
}

struct Record {
    var positive: Int
    var negative: Int
    var date: Date
}

// Main view for mood tracking
struct ContentView: View {
    @State var Size: String = ""
    @State var emotion = Color.orange
    @State var workinghour: Double = 8.0
    @State var selectedDate = Date()  // Date input
    @State var menu: [Moods] = []
    @State var records: [Record] = []
//    @State var Positive :Int = 0
//    @State var Negative :Int = 0
    

    // Function to return the appropriate emoji and mood description based on the selected emotion (emotion)
    func emojiForMood() -> (emoji: String, description: String) {
        switch emotion {
        case Color.orange:
            return ("😡", "Angry")
        case Color.yellow:
            return ("😄", "Happy")
        case Color.pink:
            return ("🤩", "Productive")
        case Color.blue:
            return ("😥", "Sad")
        case Color.green:
            return ("🤒", "Sick")
        case Color.gray:
            return ("😵", "Tired")
        default:
            return ("😶", "Neutral")
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background color based on the selected mood
                emotion
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.5)
                
                VStack {
                    // Title: Mood Tracker
                    Text("Mood Tracker")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    
                    // Conditional Mood Face Display based on mood color and working hours
                    if (emotion == Color.orange || emotion == Color.blue || emotion == Color.green || emotion == Color.gray) {
                        Text(emojiForMood().emoji)  // Display the emoji based on the selected mood
                            .font(.system(size: 100))  // Set the emoji size
                            .opacity((workinghour / 22))  // Adjust opacity based on workinghour
                            .padding()
//                        Negative += 1
                    } else {
                        Text(emojiForMood().emoji)  // Display the emoji based on the selected mood
                            .font(.system(size: 100))  // Set the emoji size
                            .opacity(1 - (workinghour / 25))  // Adjust opacity based on workinghour
                            .padding()
                        //Positive += 1
                    }
                    // Mood Description
                    Text(emojiForMood().description)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    
                    // Emotion Picker
                    HStack {
                        Text("Emotion")
                            .font(.system(size: 20)) // Increased font size
                            .fontWeight(.bold)
                        Spacer()
                        Picker("", selection: $emotion) {
                            Text("Angry 😡").tag(Color.orange)
                            Text("Happy 😄").tag(Color.yellow)
                            Text("Productive 🤩").tag(Color.pink)
                            Text("Sad 😥").tag(Color.blue)
                            Text("Sick 🤒").tag(Color.green)
                            Text("Tired 😵").tag(Color.gray)
                        }
                        .pickerStyle(MenuPickerStyle())
                        .tint(emotion)
                    }
                    .padding()
                    
                    // Date Picker
                    HStack {
                        Text("Date")
                            .font(.system(size: 20)) // Increased font size
                            .fontWeight(.bold)
                        Spacer()
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                    }
                    .padding()
                    
                    // Note Field
                    HStack {
                        Text("Note")
                            .font(.system(size: 20)) // Increased font size
                            .fontWeight(.bold)
                        Spacer()
                        TextField("Tell us your feelings", text: $Size)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    .padding()
                    
                    // workinghour (Working Hours) Slider
                    VStack {
                        Text("Working Hour: \(Int(workinghour))")
                            .font(.system(size: 20)) // Increased font size
                            .fontWeight(.bold)
                        Slider(value: $workinghour, in: 1...20)
                            .tint(emotion)
                    }
                    .padding()
                    
                    // Save and Navigate
                    HStack {
                        Button(action: {
                            let Moods = Moods(emotion: emotion, Size: Size,  workinghour: workinghour, date: selectedDate)
                            menu.append(Moods)
                            // Clear the input fields after saving
                            if (emotion == Color.orange || emotion == Color.blue || emotion == Color.green || emotion == Color.gray) {
                                let newRecord = Record(positive: 0, negative: 1, date: selectedDate)
                                records.append(newRecord)
                            } else {
                                let newRecord = Record(positive: 1, negative: 0, date: selectedDate)
                                records.append(newRecord)
                            }
                            workinghour = 8
                            emotion = .orange
                            selectedDate = Date()
                            
            
                            
                        }) {
                            Label("Save", systemImage: "square.and.arrow.down.on.square")
                                .font(.headline)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: MenuView(menu: menu, records: records)) {
                            Text("Next")
                                .font(.headline)
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .navigationTitle("")
        }

    }
}

// View displaying saved mood entries
struct MenuView: View {
    var menu: [Moods]
    var records: [Record]
    
    // State variables for month and year selection
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    
    // Array of months for picker
    let months: [String] = Calendar.current.monthSymbols
    
    // Define mood colors for background
    func backgroundColor(for month: Int) -> Color {
        switch month {
        case 1: return Color.red.opacity(0.3) // January (e.g., Angry)
        case 2: return Color.yellow.opacity(0.3) // February (e.g., Happy)
        case 3: return Color.pink.opacity(0.3) // March (e.g., Productive)
        case 4: return Color.blue.opacity(0.3) // April (e.g., Sad)
        case 5: return Color.green.opacity(0.3) // May (e.g., Sick)
        case 6: return Color.gray.opacity(0.3) // June (e.g., Tired)
        case 7: return Color.cyan.opacity(0.3)
        case 8: return Color.mint.opacity(0.3)
        case 9: return Color.teal.opacity(0.3)
        case 10: return Color.orange.opacity(0.3)
        case 11: return Color.green.opacity(0.3)
        case 12: return Color.black.opacity(0.3)
        default: return Color.white // Fallback
        }
    }

    var body: some View {
        ZStack {
            // Dynamic background color based on selected month
            backgroundColor(for: selectedMonth)
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Header for the pickers
                Text("Filter Your Mood History")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                HStack {
                    // Month Picker
                    Picker("Month", selection: $selectedMonth) {
                        ForEach(1..<13) { month in
                            Text(months[month - 1]).tag(month)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                    // Year Picker
                    Picker("Year", selection: $selectedYear) {
                        ForEach((2565...Calendar.current.component(.year, from: Date())).reversed(), id: \.self) { year in
                            Text(String(format: "%d", year)).tag(year)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    Spacer()
                }
                .padding(.horizontal)

                // Filtered mood entries
                let filteredMenu = menu.filter { Moods in
                    let components = Calendar.current.dateComponents([.month, .year], from: Moods.date)
                    return components.month == selectedMonth && components.year == selectedYear
                }

                // Sorting by date before displaying
                let sortedMenu = filteredMenu.sorted { $0.date > $1.date }

                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3)) {
                        ForEach(sortedMenu) { item in
                            NavigationLink(destination: DetailView(Moods: item, records: records)) {
                                moodItemView(for: item)  // Extracted view creation logic
                            }
                        }
                    }
                    .padding()
                }
                NavigationLink(destination: Analysis(records: records)) {
                    Text("Analysis")
                        .font(.headline)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Your Mood History")
            .foregroundColor(.black) // Ensure text is readable against background
        }
    }

    // This function returns the view for each mood item
    func emojiForMood(_ emotion: Color) -> String {
        switch emotion {
        case Color.orange:
            return "😡"  // Angry
        case Color.yellow:
            return "😄"  // Happy
        case Color.pink:
            return "🤩"  // Productive
        case Color.blue:
            return "😥"  // Sad
        case Color.green:
            return "🤒"  // Sick
        case Color.gray:
            return "😵"  // Tired
        default:
            return "😶"  // Neutral face (fallback)
        }
    }
    @ViewBuilder
    func moodItemView(for item: Moods) -> some View {
        ZStack {
            // Conditional background with the mood emoji
            if (item.emotion == Color.orange || item.emotion == Color.blue || item.emotion == Color.green || item.emotion == Color.gray) {
                Text(emojiForMood(item.emotion))  // Display the emoji based on the selected mood
                
                    .font(.system(size: 75))  // Set the emoji size
                    .background(.white)
                    .opacity((item.workinghour / 22))  // Adjust opacity based on workinghour
                    .padding()
            } else {
                Text(emojiForMood(item.emotion))  // Display the emoji based on the selected mood
                    .font(.system(size: 75))  // Set the emoji size
                    .background(.white)
                    .opacity(1 - (item.workinghour / 25))  // Adjust opacity based on workinghour
                    .padding()
            }
            
            // The main emoji icon
 
        }
    }
}

// Detail view to display mood details (you can fill this in as needed)
struct DetailView: View {
    var Moods: Moods
    var records: [Record]
    var body: some View {
        ZStack{
            Color.cyan.opacity(0.3)
                .edgesIgnoringSafeArea(.all)

            VStack {
                
                if ((Moods.emotion == Color.red)||(Moods.emotion == Color.blue)||(Moods.emotion == Color.green)||(Moods.emotion == Color.gray)){
                    Text(emojiForMood(Moods.emotion))  // Display the emoji based on the selected mood
                        .font(.system(size: 75))  // Set the emoji size
                        .opacity((Moods.workinghour / 22))  // Lower hours -> higher opacity, higher hours -> lower opacity
                        .padding()
                }else{
                    Text(emojiForMood(Moods  .emotion))  // Display the emoji based on the selected mood
                        .font(.system(size: 75))  // Set the emoji size
                        .opacity(1 - (Moods.workinghour / 25))  // Lower hours -> higher opacity, higher hours -> lower opacity
                        .padding()
                }
                
                
                Text(Moods.date, style: .date)
                    .font(.title2)
                    .padding()
                
                Text("Mood: \(moodDescription(Moods.emotion))")  // Show the mood description
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .padding()
                
                Text("Working Hour: \(Int(Moods.workinghour))")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title2)
                    .padding()
                
                Text("Note: \(Moods.Size)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title2)
                    .padding()
                Spacer()
            }

            .navigationTitle("Mood Details")
        }
    }
        
        
        // Function to return the appropriate emoji based on the emotion (emotion)
        func emojiForMood(_ emotion: Color) -> String {
            switch emotion {
            case Color.orange:
                return "😡"  // Angry
            case Color.yellow:
                return "😄"  // Happy
            case Color.pink:
                return "🤩"  // Productive
            case Color.blue:
                return "😥"  // Sad
            case Color.green:
                return "🤒"  // Sick
            case Color.gray:
                return "😵"  // Tired
            default:
                return "😶"  // Neutral face (fallback)
            }
        }
        
        // Function to return mood description based on emotion
        func moodDescription(_ emotion: Color) -> String {
            switch emotion {
            case Color.orange:
                return "Angry"
            case Color.yellow:
                return "Happy"
            case Color.pink:
                return "Productive"
            case Color.blue:
                return "Sad"
            case Color.green:
                return "Sick"
            case Color.gray:
                return "Tired"
            default:
                return "Neutral"
            }
        }
        
    
    
    
}
struct Analysis: View {
    var records: [Record] // Accept records as a parameter
    @State private var showAlert = false
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    
    let months: [String] = Calendar.current.monthSymbols
    func backgroundColor(for month: Int) -> Color {
        switch month {
        case 1: return Color.red.opacity(0.3) // January (e.g., Angry)
        case 2: return Color.yellow.opacity(0.3) // February (e.g., Happy)
        case 3: return Color.pink.opacity(0.3) // March (e.g., Productive)
        case 4: return Color.blue.opacity(0.3) // April (e.g., Sad)
        case 5: return Color.green.opacity(0.3) // May (e.g., Sick)
        case 6: return Color.gray.opacity(0.2) // June (e.g., Tired)
        case 7: return Color.cyan.opacity(0.3)
        case 8: return Color.mint.opacity(0.3)
        case 9: return Color.teal.opacity(0.3)
        case 10: return Color.orange.opacity(0.3)
        case 11: return Color.green.opacity(0.3)
        case 12: return Color.black.opacity(0.1)
        default: return Color.white // Fallback
        }
    }
    
    var body: some View {
        ZStack {
            // Dynamic background color based on selected month
            backgroundColor(for: selectedMonth)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Mood Analysis")
                    .font(.largeTitle)
                    .padding()
                
                HStack {
                    // Month Picker
                    Picker("Month", selection: $selectedMonth) {
                        ForEach(1..<13) { month in
                            Text(months[month - 1]).tag(month)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Year Picker
                    Picker("Year", selection: $selectedYear) {
                        ForEach((2565...Calendar.current.component(.year, from: Date())).reversed(), id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Filter records based on selected month and year
                let filteredRecords = records.filter { record in
                    let components = Calendar.current.dateComponents([.month, .year], from: record.date)
                    return components.month == selectedMonth && components.year == selectedYear
                }
                
                // Count positive and negative moods
                let positiveCount = filteredRecords.reduce(0) { $0 + $1.positive }
                let negativeCount = filteredRecords.reduce(0) { $0 + $1.negative }
                let totalCount = positiveCount + negativeCount
                
                // Calculate percentages
                let positivePercentage = totalCount > 0 ? Double(positiveCount) / Double(totalCount) * 100 : 0
                let negativePercentage = totalCount > 0 ? Double(negativeCount) / Double(totalCount) * 100 : 0
                
                // Display the chart
                HStack {
                    Chart {
                        BarMark(x: .value("Type", "Positive"), y: .value("Count", positiveCount))
                            .foregroundStyle(.green)
                        BarMark(x: .value("Type", "Negative"), y: .value("Count", negativeCount))
                            .foregroundStyle(.red)
                    }
                    .frame(height: 300)
                    .padding()
                }
                .onChange(of: selectedMonth) { oldValue, newValue in
                    if negativeCount > 16 {
                        showAlert = true
                    }else{
                        showAlert = false
                    }
                }
                
                HStack {
                    Label("Positive: \(positiveCount)", systemImage: "plus.circle")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    
                    Label("Negative: \(negativeCount)", systemImage: "minus.circle")
                        .font(.headline)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                
                // Display percentages
                VStack {
                    Text(String(format: "Positive: %.1f%%", positivePercentage))
                        .font(.title)
                        
                        .foregroundColor(.green)
                    Text(String(format: "Negative: %.1f%%", negativePercentage))
                        .font(.title)
                        .foregroundColor(.red)
                }
                .padding(.top)
                
                Spacer()
            }
            
            .alert(isPresented: $showAlert) { // Alert will be presented based on this state
                Alert(
                    title: Text("Danger"),
                    message: Text("You should see a psychiatrist"),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            .onAppear {
                let filteredRecords = records.filter { record in
                    let components = Calendar.current.dateComponents([.month, .year], from: record.date)
                    return components.month == selectedMonth && components.year == selectedYear
                }
                
                // Count positive and negative moods
                let positiveCount = filteredRecords.reduce(0) { $0 + $1.positive }
                let negativeCount = filteredRecords.reduce(0) { $0 + $1.negative }
                
                if negativeCount > 16 {
                    showAlert = true
                }else{
                    showAlert = false
                }
                
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            // You should provide sample records for previewing.
            ContentView()
        }
    }
}
