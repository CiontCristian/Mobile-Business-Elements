package tema2.kotlingamewishlist

import android.app.AlertDialog
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Button
import androidx.navigation.fragment.findNavController
import kotlinx.android.synthetic.main.fragment_list.*
import tema2.kotlingamewishlist.model.Game

class ListFragment : Fragment() {

    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        activity?.title = "Wishlist"

        return inflater.inflate(R.layout.fragment_list, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val dbHelper = DBHandler(view.context)
        val arrayAdapter = view.context?.let {
            ArrayAdapter(
                it,
                android.R.layout.simple_list_item_1,
                dbHelper.getAllGames()
            )
        }
        wishlistView.adapter = arrayAdapter

        view.findViewById<Button>(R.id.buttonGoToAddFragment).setOnClickListener {
            findNavController().navigate(R.id.action_ListFragment_to_AddFragment)
        }

        wishlistView.onItemLongClickListener =
            AdapterView.OnItemLongClickListener { parent, _, position, _ ->
                val builder = AlertDialog.Builder(view.context)
                val currentGame : Game = parent.getItemAtPosition(position) as Game
                builder.setMessage("Are you sure you want to remove " + currentGame.title + "?")
                    .setCancelable(false)
                    .setPositiveButton("Yes") { dialog, _ ->
                        dbHelper.removeGame(currentGame)
                        arrayAdapter?.clear()
                        arrayAdapter?.addAll(dbHelper.getAllGames())
                        arrayAdapter?.notifyDataSetChanged()
                        dialog.dismiss()
                    }
                    .setNegativeButton("No") { dialog, _ ->
                        dialog.dismiss()
                    }
                val alert = builder.create()
                alert.show()

                true
            }
    }


}