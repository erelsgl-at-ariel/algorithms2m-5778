// Erel Segal-Halevi
pragma solidity ^0.4.24;

contract Partition {
    int[] public input;

    constructor(int[] newInput) public {
        input = newInput;
        sort(input);
    }
    
    // calculate the sum of the given array of ints:
    function sum(int[] array) pure private returns(int) {
      int result=0;
      for (uint i=0; i<array.length; ++i)
        result += array[i];
      return result;
    }

    function sort(int[] storage arr) private {
        if (arr.length == 0)
            return;
        quickSort(arr, 0, arr.length-1);
    }
    
    function quickSort(int[] storage arr, uint left, uint right) private {
        uint i = left;
        uint j = right;
        int pivot = arr[left + (right - left) / 2];
        while (i <= j) {
            while (arr[i] < pivot) i++;
            while (pivot < arr[j]) j--;
            if (i <= j) {
                (arr[i], arr[j]) = (arr[j], arr[i]);
                i++;
                j--;
            }
        }
        if (left < j)
            quickSort(arr, left, j);
        if (i < right)
            quickSort(arr, i, right);
    }
    
    function add(int[] storage array1, int[] array2) private {
        for (uint i=0; i<array2.length; ++i)
            array1.push(array2[i]);
    }
    
    int[] public parts12;

    function solve(int[] part1, int[] part2) public {
        // verify that the sum of the two parts is the same:
        require(sum(part1)==sum(part2));

        // verify that the two parts are indeed a partition of the input:
        parts12.length=0;
        add(parts12, part1);
        add(parts12, part2);
        sort(parts12);
        
        require(parts12.length==input.length);
        for (uint i=0; i<parts12.length; ++i)
            require(parts12[i]==input[i]);

        // It is correct - send all balance to the happy solver:
        msg.sender.transfer(address(this).balance);
    }
}


