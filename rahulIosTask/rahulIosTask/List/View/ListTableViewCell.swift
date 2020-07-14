//
//  ListTableViewCell.swift
//  rahulIosTask
//
//  Created by Rahul Patel on 07/07/20.
//  Copyright © 2020 Rahul Patel. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

  private let placeholderImage = "placeholderImage"

  
  // MARK: - Set Cell Data
    var postData:ListResponsesub?{
        willSet(newValue){
          if let title = newValue?.title{
            self.titleLabel.text = title
              self.descriptionLabel.text = newValue?.description
            if let strUrlUserLogo = newValue?.imageHref?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                    let imgUrl = URL(string: strUrlUserLogo) {
                    if strUrlUserLogo == "N/A"{
                        self.listImageView.image = UIImage(named: placeholderImage)
                    }
                    else{
                      self.listImageView.loadImageWithUrl(imgUrl)
                    }
                }
            else{
              self.listImageView.image = UIImage(named: placeholderImage)
            }
          }
        }
    }


// MARK: - Initialize Cell detail
    let listImageView:ImageLoader = {
        let img = ImageLoader()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 35
        img.clipsToBounds = true
        return img
    }()


    let titleLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let descriptionLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor =  .black
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(listImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)

      // MARK: - set up constrain
        listImageView.topAnchor.constraint(equalTo:self.contentView.topAnchor, constant:10).isActive = true
        listImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        listImageView.widthAnchor.constraint(equalToConstant:70).isActive = true
        listImageView.heightAnchor.constraint(equalToConstant:70).isActive = true

        titleLabel.topAnchor.constraint(equalTo:self.contentView.topAnchor, constant:10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo:self.listImageView.trailingAnchor, constant:10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true

        descriptionLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor, constant:10).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo:self.titleLabel.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor, constant:1).isActive = true
      let descriptionLabelHeightConstraint = descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 90)
          descriptionLabelHeightConstraint.priority = UILayoutPriority.init(999)
          descriptionLabelHeightConstraint.isActive = true

    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

}
