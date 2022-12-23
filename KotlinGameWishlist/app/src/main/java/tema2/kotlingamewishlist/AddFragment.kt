package tema2.kotlingamewishlist

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.RadioButton
import androidx.navigation.fragment.findNavController
import kotlinx.android.synthetic.main.fragment_add.*
import tema2.kotlingamewishlist.model.Game

class AddFragment : Fragment() {

    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {

        activity?.title = "Expand wishlist"
        return inflater.inflate(R.layout.fragment_add, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val dbHelper = DBHandler(view.context)

        view.findViewById<Button>(R.id.buttonAddGame).setOnClickListener {
            val button = view.findViewById(radioPegi18Add.checkedRadioButtonId) as RadioButton
            val newGame: Game = Game(null, editTitleAdd.text.toString(), editDeveloperAdd.text.toString(), editPriceAdd.text.toString().toInt(),
                editRatingAdd.text.toString().toFloat(), editGenreAdd.text.toString(), button.text.toString())
            //ListFragment.wishList.add(newGame);
            dbHelper.addGame(newGame);
            findNavController().popBackStack();
        }
    }
}