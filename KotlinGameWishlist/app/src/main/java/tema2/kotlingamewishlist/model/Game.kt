package tema2.kotlingamewishlist.model

data class Game(
    var id: Int?, var title: String = "", var developer: String = "", var price: Int = 0, var rating: Float = 0f, var genre: String = "",
    var pegi18: String = "") {

    override fun toString(): String {
        return "id=$id, title='$title', developer='$developer', price=$price, rating=$rating, genre='$genre', pegi18='$pegi18'"
    }
}