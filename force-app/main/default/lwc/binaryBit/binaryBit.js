import { LightningElement } from 'lwc';

export default class BinaryBit extends LightningElement {

    handleProcessClick() {
        console.log('Button clicked!');  // Butona tıklanıldığında çalışıp çalışmadığını kontrol edin.

        // Basit bir test için kelimeyi alalım
        const word = this.template.querySelector('#inputWord').value;
        console.log('Input Word:', word);  // Girilen kelimeyi kontrol edin.

        if (!word) {
            console.log('No word entered, exiting.');
            return; // Eğer input boşsa işlemleri yapma
        }

        // Test için sadece basit bir işlem yapalım
        const upperWord = word.toUpperCase();
        console.log('Uppercased Word:', upperWord);

        // Test için basit bir sonuç gösterelim
        this.template.querySelector('#binaryString').textContent = 'Uppercased Word: ' + upperWord;
    

        // Bu noktaya kadar çalışıp çalışmadığını kontrol edin
        console.log('Proceeding with processing the word.');
        
        // Binary String oluştur
        let binaryString = '';
        for (let i = 0; i < word.length; i++) {
            let binaryChar = word.charCodeAt(i).toString(2).padStart(8, '0');
            binaryString += binaryChar + ' ';
        }
        binaryString = binaryString.trim();
        console.log('Binary String:', binaryString);  // Binary String sonucunu kontrol edin.

        // Decoded/Raw diziyi oluştur
        let binaryArray = binaryString.split(' ');
        console.log('Binary Array:', binaryArray);  // Binary Array dizisini kontrol edin.
        
        let rearrangedBinary = [
            binaryArray[3] || '',
            binaryArray[2] || '',
            binaryArray[1] || '',
            binaryArray[0] || ''
        ].join(' ').trim();
        console.log('Rearranged Binary:', rearrangedBinary);  // Rearranged Binary sonucunu kontrol edin.

        // Dinamik XOR pattern'i bulma ve Encoded Binary'yi oluşturma
        let xorPattern = ["01001011", "01000111", "01011111", "01110010"];
        let newBinaryArray = [];

        for (let i = 0; i < binaryArray.length; i++) {
            let originalBits = parseInt(rearrangedBinary.split(" ")[i] || '0', 2);
            let xorBits = parseInt(xorPattern[i], 2);
            let newBits = (originalBits ^ xorBits).toString(2).padStart(8, '0');
            newBinaryArray.push(newBits);
            console.log(`XOR Result [${i}]:`, newBits);  // Her bir XOR sonucunu kontrol edin.
        }

        let encodedBinary = newBinaryArray.join(' ');
        console.log('Encoded Binary:', encodedBinary);  // Encoded Binary sonucunu kontrol edin.

        // Decimal değerini hesapla
        let outputDec = parseInt(encodedBinary.replace(/\s+/g, ''), 2);
        console.log('Output (dec):', outputDec);  // Decimal sonucunu kontrol edin.

        // Sonuçları ekranda göster
        this.template.querySelector('#binaryString').textContent = 'Binary String: ' + binaryString;
        this.template.querySelector('#decodedRaw').textContent = 'Decoded/Raw: ' + rearrangedBinary;
        this.template.querySelector('#encodedBinary').textContent = 'Encoded Binary: ' + encodedBinary;
        this.template.querySelector('#outputDec').textContent = 'Output (dec): ' + outputDec;
    }
}
