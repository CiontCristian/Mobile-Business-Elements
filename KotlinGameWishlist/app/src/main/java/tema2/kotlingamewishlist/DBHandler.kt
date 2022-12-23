package tema2.kotlingamewishlist

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.widget.Toast
import tema2.kotlingamewishlist.model.Game

class DBHandler(private val context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null,DATABASE_VERSION){
    companion object{
        private val DATABASE_NAME = "wishlist.db"
        private val DATABASE_VERSION = 1
        val TABLE_NAME = "GAME"
        val COL_ID = "id"
        val COL_TITLE = "title"
        val COL_DEVELOPER = "developer"
        val COL_PRICE = "price"
        val COL_RATING = "rating"
        val COL_GENRE = "genre"
        val COL_PEGI18 = "pegi18"
    }

    override fun onCreate(db: SQLiteDatabase) {
        val CREATE_GAME_TABLE = ("CREATE TABLE " +
                TABLE_NAME + "("
                + "id" + " INTEGER PRIMARY KEY," +
                "title" + " TEXT," +
                "developer" + " TEXT,"+
                "price" + " INTEGER,"+
                "rating" + " FLOAT,"+
                "genre" + " TEXT,"+
                "pegi18" + " TEXT)")
        db.execSQL(CREATE_GAME_TABLE)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS "+ TABLE_NAME)
        onCreate(db)
    }

    fun addGame(game: Game):Boolean{
        var db = this.writableDatabase
        var values = ContentValues()
        values.put(COL_ID,game.id)
        values.put(COL_TITLE,game.title)
        values.put(COL_DEVELOPER,game.developer)
        values.put(COL_PRICE,game.price)
        values.put(COL_RATING,game.rating)
        values.put(COL_GENRE,game.genre)
        values.put(COL_PEGI18,game.pegi18)

        val success = db.insert(TABLE_NAME,null,values)
        db.close()
        if (success.toInt() == -1){
            Toast.makeText(context,"Insert failed",Toast.LENGTH_SHORT).show()
            return false
        }
        else{
            Toast.makeText(context,"Insert Success",Toast.LENGTH_SHORT).show()
            return true
        }
    }

    fun removeGame(game: Game){
        var db = this.writableDatabase
        val selectionArgs = arrayOf(game.id.toString())
        db.delete(TABLE_NAME, "$COL_ID = ? ",selectionArgs)
    }

    fun getAllGames():ArrayList<Game>{
        var db = this.writableDatabase
        var gameList : ArrayList<Game> = ArrayList()
        val selectAll = "SELECT * FROM "+ TABLE_NAME
        val cursor = db.rawQuery(selectAll,null)
        if (cursor.moveToFirst()){
            do{
                val game = Game(null)
                game.id = cursor.getInt(0)
                game.title = cursor.getString(1)
                game.developer = cursor.getString(2)
                game.price = cursor.getInt(3)
                game.rating = cursor.getFloat(4)
                game.genre = cursor.getString(5)
                game.pegi18 = cursor.getString(6)
                gameList.add(game)
            } while (cursor.moveToNext())
        }
        return gameList
    }

}