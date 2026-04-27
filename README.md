# 🎓 EduEnroll – Online Course Registration System
### Java Servlets + JSP + JDBC + MySQL + Apache Tomcat

---

## 📁 Project Structure

```
CourseRegistrationSystem/
├── docs/
│   └── schema.sql                          ← Run this in MySQL first
│
├── src/main/
│   ├── java/com/course/
│   │   ├── db/
│   │   │   └── DBConnection.java           ← DB connection helper
│   │   └── servlet/
│   │       ├── RegisterServlet.java
│   │       ├── LoginServlet.java
│   │       ├── LogoutServlet.java
│   │       ├── CoursesServlet.java
│   │       ├── EnrollServlet.java
│   │       └── DashboardServlet.java
│   │
│   └── webapp/
│       ├── WEB-INF/
│       │   └── web.xml                     ← Servlet mappings
│       ├── index.jsp                       ← Root redirect
│       ├── login.jsp
│       ├── register.jsp
│       ├── courses.jsp
│       └── dashboard.jsp
│
└── README.md
```

---

## ⚙️ Prerequisites

| Tool | Version |
|------|---------|
| JDK  | 11 or higher |
| Apache Tomcat | 9 or 10 |
| MySQL | 8.0+ |
| VS Code | Any recent version |

---

## 🛠️ Step-by-Step Setup in VS Code

### Step 1 – Install VS Code Extensions

Install these three extensions from the VS Code Marketplace:

- **Extension Pack for Java** (Microsoft)
- **Tomcat for Java** (Wei Shen)  
- **Community Server Connectors** (Red Hat) ← alternative

### Step 2 – Set Up the Database

1. Open MySQL Workbench (or any MySQL client).
2. Run the file `docs/schema.sql`.
   - This creates the `course_registration` database, all three tables, and 8 sample courses.
3. Edit `DBConnection.java` to match your MySQL credentials:
   ```java
   private static final String DB_USER     = "root";   // ← your username
   private static final String DB_PASSWORD = "root";   // ← your password
   ```

### Step 3 – Add the MySQL Connector JAR

1. Download **mysql-connector-j-x.x.x.jar** from:  
   https://dev.mysql.com/downloads/connector/j/

2. Place the JAR file here:
   ```
   src/main/webapp/WEB-INF/lib/mysql-connector-j-x.x.x.jar
   ```
   (Create the `lib` folder if it does not exist.)

### Step 4 – Compile the Java Classes

Option A – **Maven** (recommended): Add a `pom.xml` and run `mvn package`.

Option B – **Manual compilation with javac**:
```bash
# From the project root:
mkdir -p out

javac -cp "path/to/tomcat/lib/servlet-api.jar:src/main/webapp/WEB-INF/lib/mysql-connector-j-x.x.x.jar" \
      -d out \
      src/main/java/com/course/db/DBConnection.java \
      src/main/java/com/course/servlet/*.java
```

### Step 5 – Build the WAR / Deploy to Tomcat

**Using the Tomcat for Java extension:**

1. Click the Tomcat icon in the VS Code sidebar.
2. Click **+** → select your Tomcat installation directory.
3. Right-click your project → **Run on Tomcat Server**.

**Manually (without extension):**

1. Copy compiled `.class` files into:
   ```
   webapp/WEB-INF/classes/com/course/db/
   webapp/WEB-INF/classes/com/course/servlet/
   ```
2. Copy the entire `webapp/` folder into Tomcat's `webapps/CourseRegistrationSystem/`.
3. Start Tomcat:
   ```bash
   # Windows
   C:\tomcat\bin\startup.bat

   # macOS / Linux
   /opt/tomcat/bin/startup.sh
   ```

---

## 🌐 Access the Application

Once Tomcat is running, open your browser and go to:

```
http://localhost:8080/CourseRegistrationSystem/
```

The root page automatically redirects to `/login`.

| Page | URL |
|------|-----|
| Login | http://localhost:8080/CourseRegistrationSystem/login |
| Register | http://localhost:8080/CourseRegistrationSystem/register |
| Courses | http://localhost:8080/CourseRegistrationSystem/courses |
| Dashboard | http://localhost:8080/CourseRegistrationSystem/dashboard |
| Logout | http://localhost:8080/CourseRegistrationSystem/logout |

---

## 🗺️ Application Flow

```
/ (index.jsp)
   │
   ├── Not logged in ──► /login  ──► /register
   │                          │
   │                     POST /login
   │                          │
   └── Logged in ─────► /dashboard
                              │
                         /courses ──► POST /enroll ──► /courses
                              │
                         POST /enroll?action=unenroll
```

---

## 🔐 Session Handling

- On successful login a `HttpSession` is created with attributes:
  - `userId` (int)
  - `userName` (String)
  - `userEmail` (String)
- Session timeout: **30 minutes** (configurable in `web.xml`).
- Every protected servlet checks for the session at the top and redirects to `/login` if absent.

---

## 💡 Beginner Tips

| Issue | Fix |
|-------|-----|
| `ClassNotFoundException: com.mysql.cj.jdbc.Driver` | JAR not in `WEB-INF/lib` |
| `Access denied for user 'root'@'localhost'` | Wrong password in `DBConnection.java` |
| `Unknown database 'course_registration'` | Run `schema.sql` first |
| Port 8080 in use | Change Tomcat port in `conf/server.xml` |
| 404 on any URL | Context path wrong – check Tomcat deployment name |

---

## 🚀 Future Improvements

- Hash passwords with **BCrypt** (add `bcrypt.jar` to `WEB-INF/lib`)
- Add pagination to the course list
- Add an admin panel to manage courses
- Use a connection pool (Apache DBCP or HikariCP)
- Add email verification on registration
