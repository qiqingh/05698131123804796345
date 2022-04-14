sudo apt-get update
sudo apt-get install qemu -y
sudo apt-get install uml-utilities -y
sudo apt-get install sshpass -y
# for sending the email
sudo apt-get install sendmail -y
sudo apt-get install mutt -y
# for systemctl 
sudo apt-get install systemd -y

###### prepare python  #####
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash  Miniconda3-latest-Linux-x86_64.sh -b -p ~/miniconda3 -f
eval "$(~/miniconda3/bin/conda shell.bash hook)"
conda init
source ~/.bashrc
conda create -n prosec python=3.7 pip -y
conda activate prosec
pip install tailer
echo "--------------------------------------------------------"
echo ""
echo "Please execute: source ~/.bashrc; conda activate prosec;"
echo ""
echo "--------------------------------------------------------"
rm Miniconda3-latest-Linux-x86_64.sh -b -p ~/miniconda3 -f
#####  #####

##### Install zeek #######
python _10_install_zeek.py 

