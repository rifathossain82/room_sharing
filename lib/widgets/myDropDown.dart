import 'package:flutter/material.dart';

Widget myDropDown(
    List<String> items,   //from main
    String value, //from main
    String hintText,
    void onChange(val) //from main
    )
{
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: DropdownButton<String>(
      icon: Icon(Icons.keyboard_arrow_down),
      elevation: 0,
      hint: Text(hintText),
      value: value.isEmpty?null :value,
      onChanged: (val){
        onChange(val);
      },
      items: items.map<DropdownMenuItem<String>>((String val){
        return DropdownMenuItem(
          child: Text(val,style: TextStyle(color: Colors.black),),
          value: val,
        );
      }).toList(),
      dropdownColor: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}



/*
  var selectedDivision=divisionList[0];
  var selectedDistrict='Select District';
  var selectedUpazila='Select Upazila';

    myDropDown(divisionList, selectedDivision, (val){
            setState(() {
              selectedDivision=val;

              /*
              if(selectedDivision==divisionList[0]){
                districtList=list_of_divisionList[0];
              }
              else if(selectedDivision==divisionList[1]){
                districtList=list_of_divisionList[1];
              }
              else if(selectedDivision==districtList[2]){
                districtList=list_of_divisionList[2];
              }
              else if(selectedDivision==divisionList[3]){
                districtList=list_of_divisionList[3];
              }
              else if(selectedDivision==divisionList[4]){
                districtList=list_of_divisionList[4];
              }
              else if(selectedDivision==divisionList[5]){
                districtList=list_of_divisionList[5];
              }
              else if(selectedDivision==divisionList[6]){
                districtList=list_of_divisionList[6];
              }
              else if(selectedDivision==divisionList[7]){
                districtList=list_of_divisionList[7];
              }
              else{
              }
               */
            });
          }),




            /*
  districtList!=null?
          myDropDown(districtList, selectedDistrict, (val){
            setState(() {
              selectedDistrict=val;
            });
          }):Center(),
   */

  // Widget buildProductCategory(Size size){
  //   return SizedBox(
  //     width: size.width,
  //     height: size.height*0.08,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //       child: TextField(
  //         maxLines: 1,
  //         keyboardType: TextInputType.number,
  //         readOnly: true,
  //         controller: categoryController,
  //         decoration: InputDecoration(
  //           labelText: 'Product category',
  //           suffix: myDropDown(productCategoryList, '', (val) {
  //             setState(() {
  //               categoryController.text=val;
  //             });
  //           }),
  //           border: OutlineInputBorder(),
  //         ),
  //       ),
  //     ),
  //   );
  // }
 */