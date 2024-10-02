import { LightningElement, track } from 'lwc';

export default class XorOperator extends LightningElement {

    @track inputText = '';
    @track binaryString = '';
    @track decodedRaw = '';
    @track encodedValue = '';
    @track encodedBinary = '';
    @track decodedText = '';

    handleInputChange(event) {
        this.inputText = event.target.value;
    }

    textToBinary(text) {
        console.log('Converting text to binary:', text);
        const binary = text.split('').map(char => char.charCodeAt(0).toString(2).padStart(8, '0')).join('');
        console.log('Binary String:', binary);
        return binary;
    }

    applyBitManipulation(binaryString) {
        console.log('Applying bit manipulation to:', binaryString);
        const binaryArray = [];
        for (let i = 0; i < binaryString.length; i += 8) {
            binaryArray.push(binaryString.slice(i, i + 8));
        }
    
        const rearrangedBinary = [
            binaryArray[3], 
            binaryArray[2], 
            binaryArray[1], 
            binaryArray[0]  
        ].join(" ");
    
        console.log('Rearranged Binary:', rearrangedBinary);
        return rearrangedBinary.replace(/\s+/g, ''); 
    }

    generateDynamicBinary() {
        const dynamicBinary = "01001011 01000111 01011111 01110010";
        console.log('Generated Dynamic Binary:', dynamicBinary);
        return dynamicBinary;
    }

    performXOROperation(decodedRaw, dynamicBinary) {
        console.log('Performing XOR Operation on:', decodedRaw, dynamicBinary);
        const decodedArray = decodedRaw.match(/.{1,8}/g); 
        const dynamicArray = dynamicBinary.split(" ");

        let xorResultArray = decodedArray.map((decodedByte, index) => {
            let xorResult = parseInt(decodedByte, 2) ^ parseInt(dynamicArray[index], 2);
            return xorResult.toString(2).padStart(8, '0');
        });

        const xorResult = xorResultArray.join(' ');
        console.log('XOR Result:', xorResult);
        return xorResult;
    }

    generateDynamicDecodedToBinary(){
        const dynamicDecodedBinary = "01101011 01000111 01011111 01110010";
        console.log('Generated Dynamic Decoded Binary:', dynamicDecodedBinary);
        return dynamicDecodedBinary;
    }

    performToXORoper(encodedRaw, SecdynamicBinary){
        console.log('Performing Second XOR Operation on:', encodedRaw, SecdynamicBinary);
        const encodedArray = encodedRaw.match(/.{1,8}/g);
        const SecdynamicArray = SecdynamicBinary.split(" ");

        let secXORresultArray = encodedArray.map((endcodedByte, index) => {
            let secXorResult = parseInt(endcodedByte, 2) ^ parseInt(SecdynamicArray[index],2);
            return secXorResult.toString(2).padStart(8, '0');
        });

        const secXorResult = secXORresultArray.join(' ');
        console.log('Second XOR Result:', secXorResult);
        return secXorResult;
    }

    reverseBitManipulation(encodedBinary) {

        console.log('Reversing Bit Manipulation on:', decodedBinary);
        const encodedBinaryArray = [];
        for(let i=0; i< decodedBinary.length; i += 8){
            encodedBinaryArray.push(encodedBinary.slice(i, i+8));
        }
    
        if (!encodedBinaryArray || encodedBinaryArray.length !== 4) {
            console.error('Error: Binary array is not correctly formed:', encodedBinaryArray);
            return ''; 
        }
    
        const reversedBits = [
            encodedBinaryArray[3],
            encodedBinaryArray[2],
            encodedBinaryArray[1],
            encodedBinaryArray[0]  
        ].join(" ");
    
        console.log('Reversed Bits:', reversedBits);
        return reversedBits.replace(/\s+/g, ''); 
    }
    
    encodeText(){
        console.log('Encoding Text:', this.inputText);
        const binaryString = this.textToBinary(this.inputText).padEnd(32, '0');
        this.binaryString = binaryString;
        console.log('Binary String with Padding:', this.binaryString);
        
        const decodedRaw = binaryString.match(/.{1,8}/g).reverse().join('');
        this.decodedRaw = decodedRaw;
        console.log('Decoded/Raw Binary:', this.decodedRaw);

        const dynamicBinary = this.generateDynamicBinary();

        const encodedBinary = this.performXOROperation(this.decodedRaw, dynamicBinary);
        this.encodedBinary = encodedBinary.replace(/\s+/g, '');
        console.log('Encoded Binary:', this.encodedBinary);

        this.encodedValue = parseInt(encodedBinary.replace(/\s+/g, ''), 2);  
        console.log('Encoded Value (Decimal):', this.encodedValue);
    }

    decodeText() {
        const SecdynamicBinary = this.generateDynamicDecodedToBinary();

        const decodedBinary = this.performToXORoper(this.encodedBinary, SecdynamicBinary);
        this.decodedBinary = decodedBinary.replace(/\s+/g, '');
       

        const binaryString = decodedBinary.match(/.{1,8}/g).reverse().join('');
        this.binaryString = binaryString;
        console.log('Decoded/Raw Binary:', this.binaryString);

        this.decodedText = encodedBinary.match(/.{1,8}/g).map(byte => String.fromCharCode(parseInt(byte, 2))).join('');
        console.log('Decoded Text:', this.decodedText); 
    }
}
