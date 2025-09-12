# CS-360 Android Development

## 🎯 Purpose
Demonstrate Android app development with Java/Kotlin, including activities, fragments, and database integration.

## 📝 Android Development Examples

### Basic Android Activity (Java)
```java
// MainActivity.java
package com.example.mobileapp;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {
    
    private EditText editTextName;
    private TextView textViewGreeting;
    private Button buttonGreet;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        // Initialize views
        editTextName = findViewById(R.id.editTextName);
        textViewGreeting = findViewById(R.id.textViewGreeting);
        buttonGreet = findViewById(R.id.buttonGreet);
        
        // Set click listener
        buttonGreet.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                greetUser();
            }
        });
    }
    
    private void greetUser() {
        String name = editTextName.getText().toString().trim();
        
        if (name.isEmpty()) {
            Toast.makeText(this, "Please enter your name", Toast.LENGTH_SHORT).show();
            return;
        }
        
        String greeting = "Hello, " + name + "! Welcome to Android!";
        textViewGreeting.setText(greeting);
    }
}
```

### Android Layout (XML)
```xml
<!-- activity_main.xml -->
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:padding="16dp"
    android:gravity="center">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Welcome to Mobile App"
        android:textSize="24sp"
        android:textStyle="bold"
        android:layout_marginBottom="32dp" />

    <EditText
        android:id="@+id/editTextName"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:hint="Enter your name"
        android:inputType="textPersonName"
        android:layout_marginBottom="16dp" />

    <Button
        android:id="@+id/buttonGreet"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Greet"
        android:layout_marginBottom="16dp" />

    <TextView
        android:id="@+id/textViewGreeting"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text=""
        android:textSize="18sp"
        android:gravity="center" />

</LinearLayout>
```

### Fragment Implementation
```java
// UserProfileFragment.java
package com.example.mobileapp;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

public class UserProfileFragment extends Fragment {
    
    private static final String ARG_USER_NAME = "user_name";
    private static final String ARG_USER_EMAIL = "user_email";
    
    private String userName;
    private String userEmail;
    
    public static UserProfileFragment newInstance(String name, String email) {
        UserProfileFragment fragment = new UserProfileFragment();
        Bundle args = new Bundle();
        args.putString(ARG_USER_NAME, name);
        args.putString(ARG_USER_EMAIL, email);
        fragment.setArguments(args);
        return fragment;
    }
    
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            userName = getArguments().getString(ARG_USER_NAME);
            userEmail = getArguments().getString(ARG_USER_EMAIL);
        }
    }
    
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, 
                           @Nullable ViewGroup container, 
                           @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_user_profile, container, false);
        
        TextView textViewName = view.findViewById(R.id.textViewUserName);
        TextView textViewEmail = view.findViewById(R.id.textViewUserEmail);
        
        textViewName.setText("Name: " + userName);
        textViewEmail.setText("Email: " + userEmail);
        
        return view;
    }
}
```

### SQLite Database Helper
```java
// DatabaseHelper.java
package com.example.mobileapp;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import java.util.ArrayList;
import java.util.List;

public class DatabaseHelper extends SQLiteOpenHelper {
    
    private static final String DATABASE_NAME = "MobileApp.db";
    private static final int DATABASE_VERSION = 1;
    
    // Users table
    private static final String TABLE_USERS = "users";
    private static final String COLUMN_ID = "id";
    private static final String COLUMN_NAME = "name";
    private static final String COLUMN_EMAIL = "email";
    private static final String COLUMN_PHONE = "phone";
    
    // Create table SQL
    private static final String CREATE_TABLE_USERS = 
        "CREATE TABLE " + TABLE_USERS + "(" +
        COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT," +
        COLUMN_NAME + " TEXT NOT NULL," +
        COLUMN_EMAIL + " TEXT UNIQUE NOT NULL," +
        COLUMN_PHONE + " TEXT" +
        ")";
    
    public DatabaseHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }
    
    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(CREATE_TABLE_USERS);
    }
    
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_USERS);
        onCreate(db);
    }
    
    // Insert user
    public long insertUser(String name, String email, String phone) {
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(COLUMN_NAME, name);
        values.put(COLUMN_EMAIL, email);
        values.put(COLUMN_PHONE, phone);
        
        long id = db.insert(TABLE_USERS, null, values);
        db.close();
        return id;
    }
    
    // Get all users
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String selectQuery = "SELECT * FROM " + TABLE_USERS;
        
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery(selectQuery, null);
        
        if (cursor.moveToFirst()) {
            do {
                User user = new User();
                user.setId(cursor.getInt(cursor.getColumnIndex(COLUMN_ID)));
                user.setName(cursor.getString(cursor.getColumnIndex(COLUMN_NAME)));
                user.setEmail(cursor.getString(cursor.getColumnIndex(COLUMN_EMAIL)));
                user.setPhone(cursor.getString(cursor.getColumnIndex(COLUMN_PHONE)));
                users.add(user);
            } while (cursor.moveToNext());
        }
        
        cursor.close();
        db.close();
        return users;
    }
    
    // Update user
    public int updateUser(User user) {
        SQLiteDatabase db = this.getWritableDatabase();
        ContentValues values = new ContentValues();
        values.put(COLUMN_NAME, user.getName());
        values.put(COLUMN_EMAIL, user.getEmail());
        values.put(COLUMN_PHONE, user.getPhone());
        
        int result = db.update(TABLE_USERS, values, 
                             COLUMN_ID + " = ?", 
                             new String[]{String.valueOf(user.getId())});
        db.close();
        return result;
    }
    
    // Delete user
    public void deleteUser(int userId) {
        SQLiteDatabase db = this.getWritableDatabase();
        db.delete(TABLE_USERS, COLUMN_ID + " = ?", 
                 new String[]{String.valueOf(userId)});
        db.close();
    }
}
```

### User Model Class
```java
// User.java
package com.example.mobileapp;

public class User {
    private int id;
    private String name;
    private String email;
    private String phone;
    
    // Constructors
    public User() {}
    
    public User(String name, String email, String phone) {
        this.name = name;
        this.email = email;
        this.phone = phone;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                '}';
    }
}
```

### RecyclerView Adapter
```java
// UserAdapter.java
package com.example.mobileapp;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import java.util.List;

public class UserAdapter extends RecyclerView.Adapter<UserAdapter.UserViewHolder> {
    
    private List<User> users;
    private OnUserClickListener listener;
    
    public interface OnUserClickListener {
        void onUserClick(User user);
        void onUserLongClick(User user);
    }
    
    public UserAdapter(List<User> users, OnUserClickListener listener) {
        this.users = users;
        this.listener = listener;
    }
    
    @NonNull
    @Override
    public UserViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_user, parent, false);
        return new UserViewHolder(view);
    }
    
    @Override
    public void onBindViewHolder(@NonNull UserViewHolder holder, int position) {
        User user = users.get(position);
        holder.bind(user);
    }
    
    @Override
    public int getItemCount() {
        return users.size();
    }
    
    class UserViewHolder extends RecyclerView.ViewHolder {
        private TextView textViewName;
        private TextView textViewEmail;
        private TextView textViewPhone;
        
        public UserViewHolder(@NonNull View itemView) {
            super(itemView);
            textViewName = itemView.findViewById(R.id.textViewUserName);
            textViewEmail = itemView.findViewById(R.id.textViewUserEmail);
            textViewPhone = itemView.findViewById(R.id.textViewUserPhone);
            
            // Set click listeners
            itemView.setOnClickListener(v -> {
                if (listener != null) {
                    listener.onUserClick(users.get(getAdapterPosition()));
                }
            });
            
            itemView.setOnLongClickListener(v -> {
                if (listener != null) {
                    listener.onUserLongClick(users.get(getAdapterPosition()));
                }
                return true;
            });
        }
        
        public void bind(User user) {
            textViewName.setText(user.getName());
            textViewEmail.setText(user.getEmail());
            textViewPhone.setText(user.getPhone());
        }
    }
}
```

### Network Request with Retrofit
```java
// ApiService.java
package com.example.mobileapp;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.DELETE;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Path;
import java.util.List;

public interface ApiService {
    
    @GET("users")
    Call<List<User>> getUsers();
    
    @GET("users/{id}")
    Call<User> getUser(@Path("id") int id);
    
    @POST("users")
    Call<User> createUser(@Body User user);
    
    @PUT("users/{id}")
    Call<User> updateUser(@Path("id") int id, @Body User user);
    
    @DELETE("users/{id}")
    Call<Void> deleteUser(@Path("id") int id);
}
```

### Network Manager
```java
// NetworkManager.java
package com.example.mobileapp;

import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class NetworkManager {
    
    private static final String BASE_URL = "https://api.example.com/";
    private static NetworkManager instance;
    private ApiService apiService;
    
    private NetworkManager() {
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(GsonConverterFactory.create())
                .build();
        
        apiService = retrofit.create(ApiService.class);
    }
    
    public static synchronized NetworkManager getInstance() {
        if (instance == null) {
            instance = new NetworkManager();
        }
        return instance;
    }
    
    public ApiService getApiService() {
        return apiService;
    }
}
```

### AsyncTask for Background Operations
```java
// LoadUsersTask.java
package com.example.mobileapp;

import android.os.AsyncTask;
import android.widget.Toast;
import java.util.List;

public class LoadUsersTask extends AsyncTask<Void, Void, List<User>> {
    
    private DatabaseHelper dbHelper;
    private UserAdapter adapter;
    private Exception exception;
    
    public LoadUsersTask(DatabaseHelper dbHelper, UserAdapter adapter) {
        this.dbHelper = dbHelper;
        this.adapter = adapter;
    }
    
    @Override
    protected List<User> doInBackground(Void... voids) {
        try {
            return dbHelper.getAllUsers();
        } catch (Exception e) {
            exception = e;
            return null;
        }
    }
    
    @Override
    protected void onPostExecute(List<User> users) {
        if (exception != null) {
            // Handle error
            return;
        }
        
        if (users != null) {
            adapter.notifyDataSetChanged();
        }
    }
}
```

## 🔍 Android Concepts
- **Activities**: Main components of Android apps
- **Fragments**: Reusable UI components
- **Layouts**: XML-based UI design
- **SQLite**: Local database storage
- **RecyclerView**: Efficient list display
- **Networking**: HTTP requests with Retrofit
- **AsyncTask**: Background thread operations
- **Model-View-Controller**: Architecture pattern

## 💡 Learning Points
- **Activities** represent screens in Android apps
- **Fragments** enable modular UI design
- **SQLite** provides local data persistence
- **RecyclerView** efficiently displays large lists
- **Retrofit** simplifies network communication
- **AsyncTask** prevents UI blocking
- **MVC pattern** separates concerns in app architecture
- **Lifecycle methods** manage component states
