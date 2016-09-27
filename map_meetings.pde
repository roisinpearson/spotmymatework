import java.util.*;
import java.util.Iterator;
import processing.serial.*;


Serial myPort;

ArrayList<User> users;
ArrayList<PVector> meetings;

void setup(){
  
  size(500,500);
  println(Serial.list());
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);
  
  loadUsers();
  loadMeetings();
  printMeetings();  
}

void loadUsers(){

  users = new ArrayList<User>();
  
  JSONObject json = loadJSONObject("https://spotmymmate.firebaseio.com/users.json");
  Set<processing.data.JSONObject> keys = json.keys();
  
  Iterator<JSONObject> it = keys.iterator();

  // Iterate through the keys
  while (it.hasNext ()) {
    // Get the ID
    String id = String.valueOf(it.next());

    // Get the JSONObject
    JSONObject item = json.getJSONObject(id);

    // Get the actual data
    String name = item.getString("name");
    double lat = item.getDouble("lat");
    double lon = item.getDouble("lon");

    User user = new User(name, lat, lon);
    
  

    users.add(user);
  }
}


void loadMeetings(){
  
  meetings = new ArrayList<PVector>();
  
  for (User u1 : users) {
    for (User u2 : users) {
      if (u1.meeting(u2)) {
        meetings.add(new PVector((float)u1.lat, (float)u1.lon));
       
      }
    }
  }
    
}

void printMeetings(){
 
  for (int i = 0; i < meetings.size() && i < 10; i++) {
    PVector meeting = meetings.get(i);

    //convert from raw lat/lon to matrix panel
    int latVal = (int)map(meeting.x, -41.277873, -41.302347, 0.0, 31.0);
    int lonVal = (int)map(meeting.y, 174.767313, 174.780665, 0.0, 31.0);

    int latValp = (int)map(meeting.x, -41.277873, -41.302347, 0.0, 500.0);
    int lonValp = (int)map(meeting.y,  174.767313, 174.780665, 0.0, 500.0);
//new
//lower left corner -41.298716, 174.769258
//upper right corner -41.283110, 174.788172

//old
//lower right corner -41.302347, 174.791587
//upper left corner -41.277873, 174.767313

//previous lats -41.277159, -41.301586
//previous lons 174.777566, 174.780665. 
   
    latVal = constrain(latVal, 0, 31); 
    lonVal = constrain(lonVal, 0, 31);

    myPort.write(latVal);
    myPort.write(lonVal);

    fill(0);
    ellipse(latValp, lonValp, 20,20);
    println(latVal + "  :  " +lonVal);
    
  }
  
  myPort.write('x');
  
}


void draw(){
  
  
  if(frameCount%(60*10) == 0){
   loadUsers();
   loadMeetings();
   printMeetings();  
  }
  
}