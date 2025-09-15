# CS-330 Game Development Basics

## 🎯 Purpose
Demonstrate fundamental game development concepts including game loops, input handling, collision detection, and basic game mechanics.

## 📝 Game Development Examples

### Game Loop and State Management
```java
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class GameEngine extends JPanel implements KeyListener, MouseListener {
    private boolean running = false;
    private Thread gameThread;
    private long lastTime = System.nanoTime();
    private double deltaTime = 0;
    private final double TARGET_FPS = 60.0;
    private final double TARGET_TIME = 1_000_000_000 / TARGET_FPS;
    
    // Game state
    private GameState currentState;
    private Player player;
    private java.util.List<Enemy> enemies;
    private java.util.List<Projectile> projectiles;
    private int score = 0;
    private boolean gameOver = false;
    
    public enum GameState {
        MENU, PLAYING, PAUSED, GAME_OVER
    }
    
    public GameEngine() {
        this.setPreferredSize(new Dimension(800, 600));
        this.setBackground(Color.BLACK);
        this.addKeyListener(this);
        this.addMouseListener(this);
        this.setFocusable(true);
        
        initializeGame();
    }
    
    private void initializeGame() {
        currentState = GameState.MENU;
        player = new Player(400, 500, 30, 30);
        enemies = new java.util.ArrayList<>();
        projectiles = new java.util.ArrayList<>();
        score = 0;
        gameOver = false;
    }
    
    public void startGame() {
        if (running) return;
        
        running = true;
        gameThread = new Thread(this::gameLoop);
        gameThread.start();
    }
    
    public void stopGame() {
        running = false;
        try {
            if (gameThread != null) {
                gameThread.join();
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    
    private void gameLoop() {
        while (running) {
            long currentTime = System.nanoTime();
            deltaTime = (currentTime - lastTime) / TARGET_TIME;
            lastTime = currentTime;
            
            update(deltaTime);
            repaint();
            
            // Cap frame rate
            try {
                long sleepTime = (long)(TARGET_TIME - (System.nanoTime() - currentTime)) / 1_000_000;
                if (sleepTime > 0) {
                    Thread.sleep(sleepTime);
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
    
    private void update(double deltaTime) {
        switch (currentState) {
            case MENU:
                updateMenu();
                break;
            case PLAYING:
                updateGame(deltaTime);
                break;
            case PAUSED:
                updatePaused();
                break;
            case GAME_OVER:
                updateGameOver();
                break;
        }
    }
    
    private void updateMenu() {
        // Menu logic here
    }
    
    private void updateGame(double deltaTime) {
        // Update player
        player.update(deltaTime);
        
        // Update enemies
        for (int i = enemies.size() - 1; i >= 0; i--) {
            Enemy enemy = enemies.get(i);
            enemy.update(deltaTime);
            
            // Remove enemies that are off-screen
            if (enemy.getY() > 600) {
                enemies.remove(i);
            }
        }
        
        // Update projectiles
        for (int i = projectiles.size() - 1; i >= 0; i--) {
            Projectile projectile = projectiles.get(i);
            projectile.update(deltaTime);
            
            // Remove projectiles that are off-screen
            if (projectile.getY() < 0 || projectile.getY() > 600) {
                projectiles.remove(i);
            }
        }
        
        // Check collisions
        checkCollisions();
        
        // Spawn enemies
        if (Math.random() < 0.02) { // 2% chance per frame
            spawnEnemy();
        }
        
        // Check game over condition
        if (player.getHealth() <= 0) {
            currentState = GameState.GAME_OVER;
        }
    }
    
    private void updatePaused() {
        // Pause logic here
    }
    
    private void updateGameOver() {
        // Game over logic here
    }
    
    private void checkCollisions() {
        // Player-projectile collisions
        for (int i = projectiles.size() - 1; i >= 0; i--) {
            Projectile projectile = projectiles.get(i);
            if (projectile.getType() == Projectile.ProjectileType.ENEMY) {
                if (player.collidesWith(projectile)) {
                    player.takeDamage(10);
                    projectiles.remove(i);
                }
            }
        }
        
        // Enemy-projectile collisions
        for (int i = enemies.size() - 1; i >= 0; i--) {
            Enemy enemy = enemies.get(i);
            for (int j = projectiles.size() - 1; j >= 0; j--) {
                Projectile projectile = projectiles.get(j);
                if (projectile.getType() == Projectile.ProjectileType.PLAYER) {
                    if (enemy.collidesWith(projectile)) {
                        enemy.takeDamage(25);
                        projectiles.remove(j);
                        if (enemy.getHealth() <= 0) {
                            enemies.remove(i);
                            score += 10;
                            break;
                        }
                    }
                }
            }
        }
    }
    
    private void spawnEnemy() {
        int x = (int)(Math.random() * (800 - 30));
        enemies.add(new Enemy(x, -30, 30, 30));
    }
    
    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2d = (Graphics2D) g;
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        
        switch (currentState) {
            case MENU:
                drawMenu(g2d);
                break;
            case PLAYING:
                drawGame(g2d);
                break;
            case PAUSED:
                drawGame(g2d);
                drawPauseOverlay(g2d);
                break;
            case GAME_OVER:
                drawGame(g2d);
                drawGameOverOverlay(g2d);
                break;
        }
    }
    
    private void drawMenu(Graphics2D g2d) {
        g2d.setColor(Color.WHITE);
        g2d.setFont(new Font("Arial", Font.BOLD, 48));
        g2d.drawString("SPACE SHOOTER", 200, 250);
        
        g2d.setFont(new Font("Arial", Font.PLAIN, 24));
        g2d.drawString("Press SPACE to start", 280, 350);
        g2d.drawString("Press ESC to quit", 300, 400);
    }
    
    private void drawGame(Graphics2D g2d) {
        // Draw background
        g2d.setColor(Color.BLACK);
        g2d.fillRect(0, 0, 800, 600);
        
        // Draw stars
        g2d.setColor(Color.WHITE);
        for (int i = 0; i < 100; i++) {
            int x = (int)(Math.random() * 800);
            int y = (int)(Math.random() * 600);
            g2d.fillOval(x, y, 2, 2);
        }
        
        // Draw player
        player.draw(g2d);
        
        // Draw enemies
        for (Enemy enemy : enemies) {
            enemy.draw(g2d);
        }
        
        // Draw projectiles
        for (Projectile projectile : projectiles) {
            projectile.draw(g2d);
        }
        
        // Draw UI
        drawUI(g2d);
    }
    
    private void drawUI(Graphics2D g2d) {
        g2d.setColor(Color.WHITE);
        g2d.setFont(new Font("Arial", Font.BOLD, 20));
        g2d.drawString("Score: " + score, 20, 30);
        g2d.drawString("Health: " + player.getHealth(), 20, 60);
    }
    
    private void drawPauseOverlay(Graphics2D g2d) {
        g2d.setColor(new Color(0, 0, 0, 128));
        g2d.fillRect(0, 0, 800, 600);
        
        g2d.setColor(Color.WHITE);
        g2d.setFont(new Font("Arial", Font.BOLD, 36));
        g2d.drawString("PAUSED", 320, 300);
    }
    
    private void drawGameOverOverlay(Graphics2D g2d) {
        g2d.setColor(new Color(0, 0, 0, 200));
        g2d.fillRect(0, 0, 800, 600);
        
        g2d.setColor(Color.RED);
        g2d.setFont(new Font("Arial", Font.BOLD, 48));
        g2d.drawString("GAME OVER", 250, 250);
        
        g2d.setColor(Color.WHITE);
        g2d.setFont(new Font("Arial", Font.PLAIN, 24));
        g2d.drawString("Final Score: " + score, 300, 350);
        g2d.drawString("Press R to restart", 280, 400);
    }
    
    // Input handling
    @Override
    public void keyPressed(KeyEvent e) {
        switch (currentState) {
            case MENU:
                if (e.getKeyCode() == KeyEvent.VK_SPACE) {
                    currentState = GameState.PLAYING;
                } else if (e.getKeyCode() == KeyEvent.VK_ESCAPE) {
                    System.exit(0);
                }
                break;
            case PLAYING:
                if (e.getKeyCode() == KeyEvent.VK_LEFT) {
                    player.setMovingLeft(true);
                } else if (e.getKeyCode() == KeyEvent.VK_RIGHT) {
                    player.setMovingRight(true);
                } else if (e.getKeyCode() == KeyEvent.VK_SPACE) {
                    player.shoot(projectiles);
                } else if (e.getKeyCode() == KeyEvent.VK_ESCAPE) {
                    currentState = GameState.PAUSED;
                }
                break;
            case PAUSED:
                if (e.getKeyCode() == KeyEvent.VK_ESCAPE) {
                    currentState = GameState.PLAYING;
                }
                break;
            case GAME_OVER:
                if (e.getKeyCode() == KeyEvent.VK_R) {
                    initializeGame();
                    currentState = GameState.PLAYING;
                }
                break;
        }
    }
    
    @Override
    public void keyReleased(KeyEvent e) {
        if (currentState == GameState.PLAYING) {
            if (e.getKeyCode() == KeyEvent.VK_LEFT) {
                player.setMovingLeft(false);
            } else if (e.getKeyCode() == KeyEvent.VK_RIGHT) {
                player.setMovingRight(false);
            }
        }
    }
    
    @Override
    public void keyTyped(KeyEvent e) {}
    
    @Override
    public void mouseClicked(MouseEvent e) {}
    
    @Override
    public void mousePressed(MouseEvent e) {}
    
    @Override
    public void mouseReleased(MouseEvent e) {}
    
    @Override
    public void mouseEntered(MouseEvent e) {}
    
    @Override
    public void mouseExited(MouseEvent e) {}
}
```

### Game Objects
```java
// Player class
public class Player {
    private double x, y;
    private int width, height;
    private double speed = 300;
    private int health = 100;
    private boolean movingLeft = false;
    private boolean movingRight = false;
    private long lastShotTime = 0;
    private final long SHOT_COOLDOWN = 200; // milliseconds
    
    public Player(double x, double y, int width, int height) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
    
    public void update(double deltaTime) {
        if (movingLeft) {
            x -= speed * deltaTime;
        }
        if (movingRight) {
            x += speed * deltaTime;
        }
        
        // Keep player on screen
        x = Math.max(0, Math.min(800 - width, x));
    }
    
    public void draw(Graphics2D g2d) {
        g2d.setColor(Color.BLUE);
        g2d.fillRect((int)x, (int)y, width, height);
        
        // Draw health bar
        g2d.setColor(Color.RED);
        g2d.fillRect((int)x, (int)y - 10, width, 5);
        g2d.setColor(Color.GREEN);
        g2d.fillRect((int)x, (int)y - 10, (int)(width * health / 100.0), 5);
    }
    
    public void shoot(java.util.List<Projectile> projectiles) {
        long currentTime = System.currentTimeMillis();
        if (currentTime - lastShotTime >= SHOT_COOLDOWN) {
            projectiles.add(new Projectile(x + width/2, y, 0, -500, Projectile.ProjectileType.PLAYER));
            lastShotTime = currentTime;
        }
    }
    
    public boolean collidesWith(Projectile projectile) {
        return x < projectile.getX() + projectile.getWidth() &&
               x + width > projectile.getX() &&
               y < projectile.getY() + projectile.getHeight() &&
               y + height > projectile.getY();
    }
    
    public void takeDamage(int damage) {
        health -= damage;
        health = Math.max(0, health);
    }
    
    // Getters and setters
    public double getX() { return x; }
    public double getY() { return y; }
    public int getWidth() { return width; }
    public int getHeight() { return height; }
    public int getHealth() { return health; }
    public void setMovingLeft(boolean movingLeft) { this.movingLeft = movingLeft; }
    public void setMovingRight(boolean movingRight) { this.movingRight = movingRight; }
}

// Enemy class
public class Enemy {
    private double x, y;
    private int width, height;
    private double speed = 100;
    private int health = 50;
    private long lastShotTime = 0;
    private final long SHOT_COOLDOWN = 1000; // milliseconds
    
    public Enemy(double x, double y, int width, int height) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
    
    public void update(double deltaTime) {
        y += speed * deltaTime;
        
        // Random shooting
        if (Math.random() < 0.01) { // 1% chance per frame
            // Enemy shooting logic would go here
        }
    }
    
    public void draw(Graphics2D g2d) {
        g2d.setColor(Color.RED);
        g2d.fillRect((int)x, (int)y, width, height);
    }
    
    public boolean collidesWith(Projectile projectile) {
        return x < projectile.getX() + projectile.getWidth() &&
               x + width > projectile.getX() &&
               y < projectile.getY() + projectile.getHeight() &&
               y + height > projectile.getY();
    }
    
    public void takeDamage(int damage) {
        health -= damage;
    }
    
    // Getters
    public double getX() { return x; }
    public double getY() { return y; }
    public int getWidth() { return width; }
    public int getHeight() { return height; }
    public int getHealth() { return health; }
}

// Projectile class
public class Projectile {
    public enum ProjectileType {
        PLAYER, ENEMY
    }
    
    private double x, y;
    private double velocityX, velocityY;
    private int width = 4;
    private int height = 10;
    private ProjectileType type;
    private Color color;
    
    public Projectile(double x, double y, double velocityX, double velocityY, ProjectileType type) {
        this.x = x;
        this.y = y;
        this.velocityX = velocityX;
        this.velocityY = velocityY;
        this.type = type;
        this.color = (type == ProjectileType.PLAYER) ? Color.YELLOW : Color.ORANGE;
    }
    
    public void update(double deltaTime) {
        x += velocityX * deltaTime;
        y += velocityY * deltaTime;
    }
    
    public void draw(Graphics2D g2d) {
        g2d.setColor(color);
        g2d.fillRect((int)x, (int)y, width, height);
    }
    
    // Getters
    public double getX() { return x; }
    public double getY() { return y; }
    public int getWidth() { return width; }
    public int getHeight() { return height; }
    public ProjectileType getType() { return type; }
}
```

### Collision Detection
```java
public class CollisionDetection {
    
    // AABB (Axis-Aligned Bounding Box) collision detection
    public static boolean checkAABBCollision(double x1, double y1, double w1, double h1,
                                           double x2, double y2, double w2, double h2) {
        return x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2;
    }
    
    // Circle collision detection
    public static boolean checkCircleCollision(double x1, double y1, double r1,
                                             double x2, double y2, double r2) {
        double dx = x2 - x1;
        double dy = y2 - y1;
        double distance = Math.sqrt(dx * dx + dy * dy);
        return distance < r1 + r2;
    }
    
    // Point in circle collision
    public static boolean checkPointInCircle(double px, double py, double cx, double cy, double radius) {
        double dx = px - cx;
        double dy = py - cy;
        return dx * dx + dy * dy <= radius * radius;
    }
    
    // Line segment collision
    public static boolean checkLineCollision(double x1, double y1, double x2, double y2,
                                           double x3, double y3, double x4, double y4) {
        double denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
        if (Math.abs(denom) < 1e-10) return false; // Lines are parallel
        
        double t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom;
        double u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denom;
        
        return t >= 0 && t <= 1 && u >= 0 && u <= 1;
    }
}
```

## 🔍 Game Development Concepts
- **Game Loop**: Update and render cycle for smooth gameplay
- **State Management**: Different game states (menu, playing, paused)
- **Input Handling**: Keyboard and mouse input processing
- **Collision Detection**: AABB, circle, and line collision algorithms
- **Object Management**: Player, enemy, and projectile systems

## 💡 Learning Points
- Game loops must balance performance and smoothness
- State machines organize complex game logic
- Collision detection algorithms vary by object shape
- Delta time ensures consistent movement regardless of frame rate
- Object pooling can improve performance for many objects
