# All For All - A civic tech united computing resources

## civic tech's common pool of computing, gpu/cpu 
### Inspirations
1. [Leela Chess Zero](https://training.lczero.org/) - Global distributed training of Leela Chess Zero
1. [Supervise.ly](https://docs.supervise.ly/customization/agents) - Bring your own Agent, [ตัวอย่าง](./agent-updater.sh)
2. [ray-project/ray](https://github.com/ray-project/ray): A distributed execution framework for Python.
3. [ColossalAI](https://colossalai.org/docs/basics/launch_colossalai)- Distributed training framework for PyTorch and TensorFlow

### Problems
โปรเจ็คหลายๆโปรเจ็คที่เราทำต้องใช้ GPU เพื่อแก้ปัญหา e.g.
1. WeSpace - Train/Inferance ต้นไม้
2. BkkRewardHunter - Inferance คนขี่จักรยานยนต์
3. politicatracka - รัน NLP
4. และอื่นๆอีกมากมาย

หลากคนมี GPU แต่ไม่ได้ใช้ เราจะรวมพลัง GPU ของทุกคนมาใช้กันได้ไหม? เพื่อแก้ปัญหาสังคม
และเราจะทำอย่างไรให้มีความเป็นมิตรและไม่รบกวนการทำงาน พร้อมทั้งแบ่งปันเงินที่ได้จากการใช้งานอย่างเป็นธรรม


คนอีกกลุ่มนึงที่เราสนใจคือเจ้าของเหมืองคริปโตซึ่งพวกเขาเหล่านั้นหลายคนเลิกที่จะขุดแต่ก็มีจีพียูที่ไม่ได้ใช้เราจะทำอย่างไรเราจึงจะ 3 ารถสร้างรายได้ให้กับเจ้าของเหมืองคริปโตเหล่านั้นและ 3 ารถแก้ปัญหาสังคมได้พร้อมๆกัน




## distributed storage
### Problem
ข้อมูล Video เป็นข้อมูลที่ดี ปลอมแปลงยาก(ประเด็น 1) เป็นหลักฐานชั้นหนึ่ง แต่มีขนาดใหญ่มีค่าใช้จ่ายสูง(ประเด็น 2) และเรากลัวจะรบกวนอาสามากเกินไป(ประเด็น 3)

### ข้อเท็จจริง
ถ้าเราจะเก็บ Video การนับคะแนนทุก`หน่วยเลือกตั้ง ~90k หน่วย (1080p, 30fps, เข้ารหัส H.265, 1 ชม) [จะใช้พื้นที่](https://www.seagate.com/as/en/video-storage-calculator/)


```math
90k * 756 MB = ~68 TB 
```

เก็บบน R2, Cloudflare [เสียเงิน](https://r2-calculator.cloudflare.com/) 

```math
$12,519.00 /yr 
```

เราไม่มีตัง 😭 ถ้าอยากเก็บจริงๆจะทำไง? 

### Proposed Solution A
Pool Cloud Storage เช่น Google Drive, Dropbox, Onedrive ของแต่ละคนมารวมกัน แล้วแยกเก็บแบบมี redundancy ชั่วคราวประมาณ 1 ปีแล้วเลิก

### Proposed Solution B
Pool Cloud Storage บนเครื่องคอมฯ ด้วย IPFS or similar

### Maintain ไง
ดู redundance count ถ้าต่ำกว่า threshold ให้เพิ่มสำเนา