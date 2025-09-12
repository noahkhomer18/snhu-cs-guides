# CS-360 Android Mobile Development

## 🎯 Purpose
Demonstrate Android app development with Java/Kotlin and modern architecture patterns.

## 📝 Android Development Examples

### Basic Activity with Layout
```java
// MainActivity.java
public class MainActivity extends AppCompatActivity {
    private EditText editTextName;
    private Button buttonSubmit;
    private TextView textViewResult;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        // Initialize views
        editTextName = findViewById(R.id.editTextName);
        buttonSubmit = findViewById(R.id.buttonSubmit);
        textViewResult = findViewById(R.id.textViewResult);
        
        // Set click listener
        buttonSubmit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String name = editTextName.getText().toString().trim();
                if (!name.isEmpty()) {
                    textViewResult.setText("Hello, " + name + "!");
                } else {
                    textViewResult.setText("Please enter your name");
                }
            }
        });
    }
}
```

```xml
<!-- activity_main.xml -->
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:padding="16dp">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Enter your name:"
        android:textSize="18sp"
        android:layout_marginBottom="8dp" />

    <EditText
        android:id="@+id/editTextName"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:hint="Your name"
        android:layout_marginBottom="16dp" />

    <Button
        android:id="@+id/buttonSubmit"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Submit"
        android:layout_gravity="center"
        android:layout_marginBottom="16dp" />

    <TextView
        android:id="@+id/textViewResult"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text=""
        android:textSize="16sp"
        android:gravity="center" />

</LinearLayout>
```

### RecyclerView with Adapter
```java
// User.java - Data Model
public class User {
    private String name;
    private String email;
    private int age;
    
    public User(String name, String email, int age) {
        this.name = name;
        this.email = email;
        this.age = age;
    }
    
    // Getters and setters
    public String getName() { return name; }
    public String getEmail() { return email; }
    public int getAge() { return age; }
}

// UserAdapter.java - RecyclerView Adapter
public class UserAdapter extends RecyclerView.Adapter<UserAdapter.UserViewHolder> {
    private List<User> users;
    
    public UserAdapter(List<User> users) {
        this.users = users;
    }
    
    @Override
    public UserViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_user, parent, false);
        return new UserViewHolder(view);
    }
    
    @Override
    public void onBindViewHolder(UserViewHolder holder, int position) {
        User user = users.get(position);
        holder.textViewName.setText(user.getName());
        holder.textViewEmail.setText(user.getEmail());
        holder.textViewAge.setText("Age: " + user.getAge());
    }
    
    @Override
    public int getItemCount() {
        return users.size();
    }
    
    public static class UserViewHolder extends RecyclerView.ViewHolder {
        TextView textViewName, textViewEmail, textViewAge;
        
        public UserViewHolder(View itemView) {
            super(itemView);
            textViewName = itemView.findViewById(R.id.textViewName);
            textViewEmail = itemView.findViewById(R.id.textViewEmail);
            textViewAge = itemView.findViewById(R.id.textViewAge);
        }
    }
}
```

### AsyncTask for Network Operations
```java
public class NetworkTask extends AsyncTask<String, Void, String> {
    private Context context;
    private ProgressDialog progressDialog;
    
    public NetworkTask(Context context) {
        this.context = context;
    }
    
    @Override
    protected void onPreExecute() {
        super.onPreExecute();
        progressDialog = new ProgressDialog(context);
        progressDialog.setMessage("Loading...");
        progressDialog.setCancelable(false);
        progressDialog.show();
    }
    
    @Override
    protected String doInBackground(String... urls) {
        String urlString = urls[0];
        String result = "";
        
        try {
            URL url = new URL(urlString);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(5000);
            connection.setReadTimeout(5000);
            
            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader reader = new BufferedReader(
                    new InputStreamReader(connection.getInputStream()));
                StringBuilder response = new StringBuilder();
                String line;
                
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                reader.close();
                result = response.toString();
            }
        } catch (Exception e) {
            e.printStackTrace();
            result = "Error: " + e.getMessage();
        }
        
        return result;
    }
    
    @Override
    protected void onPostExecute(String result) {
        super.onPostExecute(result);
        if (progressDialog.isShowing()) {
            progressDialog.dismiss();
        }
        // Handle result
        Toast.makeText(context, "Data loaded: " + result.length() + " characters", 
                      Toast.LENGTH_SHORT).show();
    }
}
```

### SQLite Database Operations
```java
// DatabaseHelper.java
public class DatabaseHelper extends SQLiteOpenHelper {
    private static final String DATABASE_NAME = "users.db";
    private static final int DATABASE_VERSION = 1;
    
    private static final String TABLE_USERS = "users";
    private static final String COLUMN_ID = "id";
    private static final String COLUMN_NAME = "name";
    private static final String COLUMN_EMAIL = "email";
    
    public DatabaseHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }
    
    @Override
    public void onCreate(SQLiteDatabase db) {
        String createTable = "CREATE TABLE " + TABLE_USERS + " (" +
                COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
                COLUMN_NAME + " TEXT NOT NULL, " +
                COLUMN_EMAIL + " TEXT NOT NULL)";
        db.execSQL(createTable);
    }
    
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_USERS);
        onCreate(db);
    }
    
    public boolean insertUser(String name, String email) {
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(COLUMN_NAME, name);
        values.put(COLUMN_EMAIL, email);
        
        long result = db.insert(TABLE_USERS, null, values);
        db.close();
        return result != -1;
    }
    
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("SELECT * FROM " + TABLE_USERS, null);
        
        if (cursor.moveToFirst()) {
            do {
                int id = cursor.getInt(cursor.getColumnIndex(COLUMN_ID));
                String name = cursor.getString(cursor.getColumnIndex(COLUMN_NAME));
                String email = cursor.getString(cursor.getColumnIndex(COLUMN_EMAIL));
                users.add(new User(name, email, 0));
            } while (cursor.moveToNext());
        }
        cursor.close();
        db.close();
        return users;
    }
}
```

### Permissions and Manifest
```xml
<!-- AndroidManifest.xml -->
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.mobileapp">

    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:theme="@style/AppTheme">
        
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        
    </application>
</manifest>
```

## 🔍 Mobile Development Concepts
- **Activities**: Main components of Android apps
- **Layouts**: XML-based UI design
- **RecyclerView**: Efficient list display
- **AsyncTask**: Background processing
- **SQLite**: Local database storage

## 💡 Learning Points
- Android development requires understanding of lifecycle
- UI components are defined in XML layouts
- Background tasks prevent UI blocking
- Local storage enables offline functionality
- Permissions control app access to device features
